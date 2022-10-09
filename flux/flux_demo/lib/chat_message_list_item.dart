// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flux_demo/app_stores.dart';

class ChatMessageListItem extends StatefulWidget {
  ChatMessageListItem(ChatMessage m)
      : message = m,
        super(key: ObjectKey(m));

  final ChatMessage message;

  @override
  State createState() => ChatMessageListItemState();
}

class ChatMessageListItemState extends State<ChatMessageListItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = CurvedAnimation(
      parent: _animationController as Animation<double>,
      curve: Curves.easeOut,
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
  //
  // ignore: member-ordering-extended
  @override
  Widget build(BuildContext context) {
    final ChatMessage message = widget.message;

    return SizeTransition(
      sizeFactor: _animation as Animation<double>,
      axisAlignment: 0.0,
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: message.sender.color,
          child: Text(message.sender.name[0]),
        ),
        title: Text(message.sender.name),
        subtitle: Text(message.text),
      ),
    );
  }
}
