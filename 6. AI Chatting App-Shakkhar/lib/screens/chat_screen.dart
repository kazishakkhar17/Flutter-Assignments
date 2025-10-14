import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/sidebar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AnimationController> _animationControllers = [];
  String? _lastChatTitle;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  AnimationController _createAnimationController() {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationControllers.add(controller);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);
    final currentChat = chatState.currentChat;

    // Detect chat change and trigger animations
    if (currentChat != null && currentChat.title != _lastChatTitle) {
      _lastChatTitle = currentChat.title;
      // Clear and recreate animation controllers when switching chats
      for (var controller in _animationControllers) {
        controller.dispose();
      }
      _animationControllers.clear();
      
      // Create new controllers for all messages and start animations
      for (int i = 0; i < currentChat.messages.length; i++) {
        final animController = _createAnimationController();
        // Stagger the animations with delay
        Future.delayed(Duration(milliseconds: i * 50), () {
          if (mounted) {
            animController.forward();
          }
        });
      }
    }

    // Auto-scroll when new messages appear
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.lightGreenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          currentChat?.title ?? 'New Chat',
          style: const TextStyle(
            color: Colors.lightGreenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.pinkAccent),
            onPressed: () {
              chatNotifier.createNewChat();
              // Clear animation controllers for new chat
              for (var controller in _animationControllers) {
                controller.dispose();
              }
              _animationControllers.clear();
            },
            tooltip: 'New Chat',
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: currentChat == null || currentChat.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.lightGreenAccent.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.lightGreenAccent.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    itemCount: currentChat.messages.length,
                    itemBuilder: (context, index) {
                      final message = currentChat.messages[index];
                      
                      // Ensure we have an animation controller for this message
                      if (_animationControllers.length <= index) {
                        final animController = _createAnimationController();
                        animController.forward();
                      }

                      final animation = CurvedAnimation(
                        parent: _animationControllers[index],
                        curve: Curves.easeOutCubic,
                      );

                      // User messages slide from right, bot messages from left
                      final slideOffset = message.role == 'user'
                          ? const Offset(1.0, 0)  // From right
                          : const Offset(-1.0, 0); // From left

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: slideOffset,
                            end: Offset.zero,
                          ).animate(animation),
                          child: ChatBubble(
                            text: message.content,
                            isUser: message.role == 'user',
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Typing indicator
          if (chatState.isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.pinkAccent,
                    child: Icon(Icons.smart_toy, color: Colors.black, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TypingDot(delay: 0),
                        const SizedBox(width: 4),
                        _TypingDot(delay: 200),
                        const SizedBox(width: 4),
                        _TypingDot(delay: 400),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.lightGreenAccent.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.lightGreenAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (value) => _sendMessage(chatNotifier),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightGreenAccent,
                        Colors.pinkAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () => _sendMessage(chatNotifier),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatNotifier chatNotifier) {
    final text = _controller.text.trim();
    if (text.isEmpty || ref.read(chatProvider).isTyping) return;

    _controller.clear();
    chatNotifier.sendMessage(text);
  }
}

// Animated typing indicator dot
class _TypingDot extends StatefulWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}