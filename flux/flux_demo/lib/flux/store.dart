// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// Original under Apache License Copyright 2015 Workiva Inc.



import 'dart:async';

import 'package:flux_demo/flux/flux_action.dart';

/// A `Store` is a repository and manager of app state. This class should be
/// extended to fit the needs of your application and its data. The number and
/// hierarchy of stores is dependent upon the state management needs of your
/// application.
///
/// General guidelines with respect to a `Store`'s data:
/// - A `Store`'s data should not be exposed for direct mutation.
/// - A `Store`'s data should be mutated internally in response to [Action]s.
/// - A `Store` should expose relevant data ONLY via public getters.
///
/// To receive notifications of a `Store`'s data mutations, `Store`s can be
/// listened to. Whenever a `Store`'s data is mutated, the `trigger` method is
/// used to tell all registered listeners that updated data is available.
///
/// In a typical application using `w_flux`, a [FluxComponent] listens to
/// `Store`s, triggering re-rendering of the UI elements based on the updated
/// `Store` data.
class Store {
  /// Construct a new [Store] instance.
  Store() {
    _streamController = StreamController<Store>();
    _stream = _streamController?.stream.asBroadcastStream();
  }

  /// Construct a new [Store] instance with a transformer.
  ///
  /// The standard behavior of the "trigger" stream will be modified. The
  /// underlying stream will be transformed using [transformer].
  ///
  /// As an example, [transformer] could be used to throttle the number of
  /// triggers this [Store] emits for state that may update extremely frequently
  /// (like scroll position).
  Store.withTransformer(StreamTransformer<dynamic, dynamic> transformer) {
    _streamController = StreamController<Store>();

    // Apply a transform to the stream if supplied.
    _stream = _streamController?.stream
        .transform<dynamic>(transformer as StreamTransformer<Store, dynamic>)
        .asBroadcastStream() as Stream<Store>?;
  }

  /// Stream controller for [_stream]. Used by [trigger].
  StreamController<Store>? _streamController;

  /// Broadcast stream of "data updated" events. Listened to in [listen].
  Stream<Store>? _stream;

  void dispose() {
    _streamController!.close();
  }

  /// Trigger a "data updated" event. All registered listeners of this `Store`
  /// will receive the event, at which point they can use the latest data
  /// from this `Store` as necessary.
  ///
  /// This should be called whenever this `Store`'s data has finished mutating in
  /// response to an action.
  void trigger() {
    _streamController!.add(this);
  }

  /// A convenience method for listening to an [action] and triggering
  /// automatically. The callback doesn't call return, so the return
  /// type of onAction is null.
  void triggerOnAction<T>(
    FluxAction<T> action, [
    dynamic Function(T payload)? onAction,
  ]) {
    if (onAction != null) {
      action.listen((T payload) async {
        await onAction(payload);
        trigger();
      });
    } else {
      action.listen((dynamic _) {
        trigger();
      });
    }
  }

  /// A convenience method for listening to an [action] and triggering
  /// automatically once the callback returns true when it completes.
  ///
  /// [onAction] will be called every time [action] is dispatched.
  /// If [onAction] returns a [Future], [trigger] will not be
  /// called until that future has resolved and the function returns either
  /// void (null) or true.
  void triggerOnConditionalAction<T>(
    FluxAction<T> action,
    FutureOr<bool> Function(T payload) onAction,
  ) {
    assert(action != null);
    action.listen((dynamic payload) async {
      // Action functions must return bool, or a Future<bool>.
      dynamic result = onAction(payload as T);
      bool wasChanged;
      if (result is Future) {
        wasChanged = await result as bool;
      } else {
        wasChanged = result as bool;
      }
      if (wasChanged) {
        trigger();
      }
    });
  }

  /// Adds a subscription to this `Store`.
  ///
  /// Each time this `Store` triggers (by calling [trigger]), indicating that
  /// data has been mutated, [onData] will be called.
  StreamSubscription<Store> listen(
    void Function(Store event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream!.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
