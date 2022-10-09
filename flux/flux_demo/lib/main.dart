import 'package:flutter/material.dart';
import 'package:flux_demo/chat_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.orangeAccent[400],
      ),
      home: const ChatScreen(),
    ),
  );
}
