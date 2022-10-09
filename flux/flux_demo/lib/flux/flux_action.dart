// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// Original under Apache License Copyright 2015 Workiva Inc.

import 'dart:async';

typedef void OnData<T>(T event);

/// A command that can be dispatched and listened to.
///
/// An [Action] manages a collection of listeners and the manner of
/// their invocation. It *does not* rely on [Stream] for managing listeners. By
/// managing its own listeners, an [Action] can track a [Future] that completes
/// when all registered listeners have completed. This allows consumers to use
/// `await` to wait for an action to finish processing.
///
///     var asyncListenerCompleted = false;
///     action.listen((_) async {
///       await new Future.delayed(new Duration(milliseconds: 100), () {
///         asyncListenerCompleted = true;
///       });
///     });
///
///     var future = action();
///     print(asyncListenerCompleted); // => 'false'
///
///     await future;
///     print(asyncListenerCompleted). // => 'true'
///
/// Providing a [Future] for listener completion makes actions far easier to use
/// when a consumer needs to check state changes immediately after invoking an
/// action.
///
class FluxAction<T> {
  final List<OnData<T>> _listeners = <OnData<T>>[];

  /// Dispatch this [Action] to all listeners. If a payload is supplied, it will
  /// be passed to each listener's callback, otherwise null will be passed.
  Future<List<dynamic>> call([T? payload]) {
    // Invoke all listeners in a microtask to enable waiting on futures. The
    // microtask queue is emptied before the event loop continues. This ensures
    // synchronous listeners are invoked in the current tick of the event loop
    // without being scheduled at the back of the event queue. A Dart [Stream]
    // behaves in a similar fashion.
    //
    // Performance benchmarks over 10,000 samples show no performance
    // degradation when dispatching actions using this action implementation vs
    // a [Stream]-based action implementation. At smaller sample sizes this
    // implementation slows down in comparison, yielding average times of 0.1 ms
    // for stream-based actions vs. 0.14 ms for this action implementation.
    return Future.wait<dynamic>(
      _listeners.map(
        (OnData<T> l) => Future<dynamic>.microtask(() => l(payload as T)),
      ),
    );
  }

  /// Cancel all subscriptions that exist on this [Action] as a result of
  /// [listen] being called. Useful when tearing down a flux cycle in some
  /// module or unit test.
  void clearListeners() => _listeners.clear();

  /// Supply a callback that will be called any time this [Action] is
  /// dispatched. A payload of type [T] will be passed to the callback if
  /// supplied at dispatch time, otherwise null will be passed. Returns an
  /// [ActionSubscription] which provides means to cancel the subscription.
  FluxActionSubscription listen(OnData<T> onData) {
    _listeners.add(onData);

    return FluxActionSubscription(() => _listeners.remove(onData));
  }
}

//
// ignore: avoid_private_typedef_functions
typedef _OnCancel = void Function();

/// A subscription used to cancel registered listeners to an [Action].
class FluxActionSubscription {
  final _OnCancel _onCancel;

  FluxActionSubscription(this._onCancel);

  /// Cancel this subscription to an [Action].
  void cancel() {
    _onCancel();
  }
}
