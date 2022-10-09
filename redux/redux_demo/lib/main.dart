import 'package:flutter/material.dart';
import 'package:redux_demo/flutter_redux_app.dart';
import 'package:redux_demo/stores/app_store.dart';

void main() {
  runApp(
    FlutterReduxApp(
      title: 'Flutter Redux Demo',
      store: appStore,
    ),
  );
}
