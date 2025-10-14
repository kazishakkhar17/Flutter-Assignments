import 'message_model.dart';

class Chat {
  String title;
  List<Message> messages;

  Chat({required this.title, required this.messages});

  Map<String, dynamic> toMap() => {
        'title': title,
        'messages': messages.map((e) => e.toMap()).toList(),
      };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        title: map['title'] ?? '',
        messages: (map['messages'] as List<dynamic>? ?? [])
            .map((e) => Message.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );

  Chat copyWith({String? title, List<Message>? messages}) {
    return Chat(
      title: title ?? this.title,
      messages: messages ?? this.messages,
    );
  }
}
