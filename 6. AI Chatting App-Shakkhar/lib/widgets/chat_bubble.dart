import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Assistant profile icon
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.smart_toy, color: Colors.black, size: 18),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.lightGreenAccent : Colors.pinkAccent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft:
                      isUser ? const Radius.circular(12) : const Radius.circular(0),
                  bottomRight:
                      isUser ? const Radius.circular(0) : const Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? Colors.lightGreenAccent.withOpacity(0.4)
                        : Colors.pinkAccent.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      text,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    )
                  : MarkdownBody(
                      data: text,
                      selectable: true, // makes assistant text selectable
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context).copyWith(
                          textTheme: const TextTheme(
                            bodyMedium:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          // User profile icon
          if (isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.lightGreenAccent,
              child: Icon(Icons.person, color: Colors.black, size: 18),
            ),
        ],
      ),
    );
  }
}
