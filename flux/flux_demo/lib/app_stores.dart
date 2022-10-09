// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flux_demo/flux/flux_action.dart';
import 'package:flux_demo/flux/store.dart';
import 'package:flux_demo/flux/store_watcher.dart';

class ChatUser {
  ChatUser({
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;
}

class ChatMessage {
  ChatMessage({
    required this.sender,
    required this.text,
  });
  final ChatUser sender;
  final String text;
}

class ChatMessageStore extends Store {
  ChatMessageStore() {
    triggerOnAction(
      setCurrentMessageAction,
      (String value) {
        _currentMessage = value;
      },
    );
    triggerOnAction(
      commitCurrentMessageAction,
      (ChatUser me) {
        final ChatMessage message = ChatMessage(
          sender: me,
          text: _currentMessage,
        );
        _messages.add(message);
        _currentMessage = '';
      },
    );
  }

  final List<ChatMessage> _messages = <ChatMessage>[];
  String _currentMessage = '';

  List<ChatMessage> get messages => List<ChatMessage>.unmodifiable(_messages);
  String get currentMessage => _currentMessage;

  bool get isComposing => _currentMessage.isNotEmpty;
}

class ChatUserStore extends Store {
  ChatUserStore() {
    final String name = "Guest${Random().nextInt(1000)}";
    final Color? color =
        Colors.accents[Random().nextInt(Colors.accents.length)][700];
    _me = ChatUser(
      name: name,
      color: color as Color,
    );
    // This store does not currently handle any actions.
  }

  ChatUser? _me;
  ChatUser? get me => _me;
}

final FluxAction<String> setCurrentMessageAction = FluxAction<String>();

final FluxAction<ChatUser> commitCurrentMessageAction = FluxAction<ChatUser>();

final StoreToken messageStoreToken = StoreToken(ChatMessageStore());
final StoreToken userStoreToken = StoreToken(ChatUserStore());
