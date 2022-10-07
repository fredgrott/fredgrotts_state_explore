// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {
  int _count = 0;
  void increment() {
    _count++;
    notifyListeners();
  }

  int get count => _count;
}
