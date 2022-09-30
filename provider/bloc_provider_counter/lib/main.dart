import 'package:bloc/bloc.dart';
import 'package:bloc_provider_counter/src/presentation/features/app/counter_app.dart';
import 'package:bloc_provider_counter/src/presentation/features/counter/observers/counter_observer.dart';
import 'package:flutter/material.dart';



void main() async {
  Bloc.observer = CounterObserver();
  runApp(CounterApp());
}
