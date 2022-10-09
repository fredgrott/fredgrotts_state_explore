// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:redux_demo/reducers/counter_reducer.dart';

final appStore = Store<int>(counterReducer, initialState: 0,);
