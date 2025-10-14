import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../api/api_service.dart';

class ChatState {
  final List<Chat> chats;
  final Chat? currentChat;
  final bool isSending;
  final bool isTyping;

  ChatState({
    required this.chats,
    this.currentChat,
    this.isSending = false,
    this.isTyping = false,
  });

  ChatState copyWith({
    List<Chat>? chats,
    Chat? currentChat,
    bool? isSending,
    bool? isTyping,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      currentChat: currentChat ?? this.currentChat,
      isSending: isSending ?? this.isSending,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState(chats: [])) {
    loadChats();
  }

  /// Load chats from Hive
  void loadChats() {
    final box = Hive.box('chatBox');

    final loadedChats = box.keys.map((key) {
      final data = box.get(key);
      if (data == null) return null;

      final mapData = Map<String, dynamic>.from(data);
      if (mapData['messages'] is! List) {
        mapData['messages'] = [];
      }

      return Chat.fromMap(mapData);
    }).whereType<Chat>().toList();

    state = state.copyWith(
      chats: loadedChats,
      currentChat: loadedChats.isNotEmpty ? loadedChats.last : null,
    );
  }

  /// Create a new chat safely
  void createNewChat() {
    final chat = Chat(title: "New Chat", messages: []);
    final updatedChats = [...state.chats, chat];
    state = state.copyWith(chats: updatedChats, currentChat: chat);

    saveChats();
  }

  /// Send message with streaming and correct context memory
  Future<void> sendMessage(String content) async {
    if (state.currentChat == null) createNewChat();

    final currentChat = state.currentChat!;
    final isFirstMessage = currentChat.messages.isEmpty;

    final updatedMessages = [
      ...currentChat.messages,
      Message(role: 'user', content: content)
    ];

    Chat updatedChat = currentChat;
    if (isFirstMessage) {
      updatedChat = currentChat.copyWith(
        title: content.length > 20 ? content.substring(0, 20) : content,
      );

      final updatedChats = state.chats.map((c) {
        if (c == currentChat) return updatedChat;
        return c;
      }).toList();

      state = state.copyWith(
        currentChat: updatedChat,
        chats: updatedChats,
      );
    } else {
      state = state.copyWith(currentChat: updatedChat);
    }

    final contextMessages = updatedMessages
        .skip((updatedMessages.length - 10).clamp(0, updatedMessages.length))
        .map((e) => {'role': e.role, 'content': e.content})
        .toList();

    state = state.copyWith(
      currentChat: updatedChat.copyWith(messages: updatedMessages),
      isTyping: true,
    );

    final reply = await ApiService.sendMessage(contextMessages);
    var displayText = '';
    for (var word in reply.split(' ')) {
      displayText += (displayText.isEmpty ? '' : ' ') + word;
      final tempMessage = Message(role: 'assistant', content: displayText);

      // Get current chat messages
      final currentMessages = List<Message>.from(state.currentChat!.messages);

      // Remove previous partial assistant message if exists
      if (currentMessages.isNotEmpty && currentMessages.last.role == 'assistant') {
        currentMessages.removeLast();
      }

      // Add new partial assistant message
      currentMessages.add(tempMessage);

      // Update state.currentChat
      state = state.copyWith(
        currentChat: state.currentChat!.copyWith(messages: currentMessages),
        isTyping: true,
      );

      // ✅ Also update state.chats
      final updatedChats = state.chats.map((c) {
        if (c.title == state.currentChat!.title) return state.currentChat!;
        return c;
      }).toList();
      state = state.copyWith(chats: updatedChats);

      await Future.delayed(const Duration(milliseconds: 80));
    }

    // Append final assistant message
    final finalMessages = [
      ...updatedMessages,
      Message(role: 'assistant', content: reply)
    ];
    state = state.copyWith(
      currentChat: state.currentChat!.copyWith(messages: finalMessages),
      isTyping: false,
    );

    // ✅ Update state.chats before saving
    final updatedChats = state.chats.map((c) {
      if (c.title == state.currentChat!.title) return state.currentChat!;
      return c;
    }).toList();
    state = state.copyWith(chats: updatedChats);

    saveChats();
  }

  /// Select existing chat
  void selectChat(Chat chat) {
    state = state.copyWith(currentChat: chat);
  }

  /// Save all chats to Hive
  void saveChats() {
    final box = Hive.box('chatBox');
    for (var i = 0; i < state.chats.length; i++) {
      final chatMap = state.chats[i].toMap();
      box.put(i.toString(), chatMap);
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
