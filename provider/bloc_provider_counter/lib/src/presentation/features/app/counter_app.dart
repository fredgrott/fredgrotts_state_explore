// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:bloc_provider_counter/src/presentation/features/counter/views/counter_page.dart';
import 'package:flutter/material.dart';

/// {@template counter_app}
/// A [MaterialApp] which sets the `home` to [CounterPage].
/// {@endtemplate}
class CounterApp extends MaterialApp {
  CounterApp({super.key}) : super(theme: ThemeData.light(),darkTheme: ThemeData.dark(),themeMode: ThemeMode.dark, home: const CounterPage(),);
}
