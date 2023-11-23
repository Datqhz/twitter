import 'package:flutter/material.dart';

import '../../shared/app_bar.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Center(
            child: Text(
              "Message",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: MyAppBar(currentPage: 4)
          ),
        ]
      );
  }
}