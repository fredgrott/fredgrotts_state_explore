// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flux_demo/app_stores.dart';
import 'package:flux_demo/chat_message_list_item.dart';
import 'package:flux_demo/flux/store.dart';
import 'package:flux_demo/flux/store_watcher.dart';

class ChatScreen extends StatefulWidget {
  /// Creates a widget that watches stores.
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with StoreWatcherMixin<ChatScreen> {
  // Never write to these stores directly. Use Actions.
  ChatMessageStore? messageStore;
  ChatUserStore? chatUserStore;

  final TextEditingController msgController = TextEditingController();

  /// Override this function to configure which stores to listen to.
  ///
  /// This function is called by [StoreWatcherState] during its
  /// [State.initState] lifecycle callback, which means it is called once per
  /// inflation of the widget. As a result, the set of stores you listen to
  /// should not depend on any constructor parameters for this object because
  /// if the parent rebuilds and supplies new constructor arguments, this
  /// function will not be called again.
  @override
  void initState() {
    super.initState();

    // Demonstrates using a custom change handler.
    messageStore = listenToStore(
      messageStoreToken,
      handleChatMessageStoreChanged,
    ) as ChatMessageStore?;

    // Demonstrates using the default handler, which just calls setState().
    chatUserStore = listenToStore(userStoreToken) as ChatUserStore?;
  }

  void handleChatMessageStoreChanged(Store store) {
    final ChatMessageStore? messageStore = store as ChatMessageStore?;
    if (messageStore!.currentMessage.isEmpty) {
      msgController.clear();
    }
    setState(() {});
  }

  Widget _buildTextComposer(
    BuildContext context,
    ChatMessageStore messageStore,
    ChatUserStore userStore,
  ) {
    dynamic commitMessage(String _) {
      commitCurrentMessageAction(userStore.me);
    }

    final ThemeData themeData = Theme.of(context);

    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            key: const Key("msgField"),
            controller: msgController,
            decoration: const InputDecoration(hintText: 'Enter message'),
            onSubmitted: commitMessage,
            onChanged: setCurrentMessageAction,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed:
                messageStore.isComposing ? () => commitMessage('') : null,
            color: messageStore.isComposing
                ? themeData.colorScheme.secondary
                : themeData.disabledColor,
          ),
        ),
      ],
    );
  }
  //
  // ignore: member-ordering-extended
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatting as ${chatUserStore!.me!.name}')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: messageStore!.messages
                  .map((ChatMessage m) => ChatMessageListItem(m))
                  .toList(),
            ),
          ),
          _buildTextComposer(context, messageStore!, chatUserStore!),
        ],
      ),
    );
  }
}
