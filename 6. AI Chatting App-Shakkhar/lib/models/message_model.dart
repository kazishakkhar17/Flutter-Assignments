class Message {
  String role; // "user" or "assistant"
  String content;
  Message({required this.role, required this.content});

  Map<String, dynamic> toMap() => {'role': role, 'content': content};
  factory Message.fromMap(Map<String, dynamic> map) =>
      Message(role: map['role'], content: map['content']);
}
