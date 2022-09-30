// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:bloc_provider_counter/src/presentation/features/counter/views/counter_page.dart';
import 'package:bloc_provider_counter/src/presentation/features/counter/views/counter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));
      expect(find.byType(CounterView), findsOneWidget,);
    },);
  },);
}
