// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:bloc_provider_counter/src/presentation/features/app/counter_app.dart';
import 'package:bloc_provider_counter/src/presentation/features/counter/views/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterApp', () {
    testWidgets('is a MaterialApp', (tester) async {
      expect(CounterApp(), isA<MaterialApp>(),);
    },);

    testWidgets('home is CounterPage', (tester) async {
      expect(CounterApp().home, isA<CounterPage>(),);
    },);

    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(CounterApp());
      expect(find.byType(CounterPage), findsOneWidget,);
    },);
  },);
}
