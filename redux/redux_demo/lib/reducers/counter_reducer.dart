// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
import 'package:redux_demo/actions/app_actions.dart';

int counterReducer(int state, dynamic action,) {
  if (action == ReduxActions.increment) {
    return state + 1;
  }

  return state;
}
