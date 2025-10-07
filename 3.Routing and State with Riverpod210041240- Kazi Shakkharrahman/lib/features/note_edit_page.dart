import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/note_provider.dart';
import 'package:go_router/go_router.dart';
import 'note_model.dart';

class NoteEditPage extends ConsumerStatefulWidget {
  final String noteId;
  const NoteEditPage({super.key, required this.noteId});

  @override
  ConsumerState<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends ConsumerState<NoteEditPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final notes = ref.read(notesProvider);
    final note =
        notes.firstWhere((n) => n.id == widget.noteId, orElse: () => Note(id: '', content: ''));
    _controller = TextEditingController(text: note.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ref
                      .read(notesProvider.notifier)
                      .edit(widget.noteId, _controller.text);
                  context.pop(); // works now because we used push
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
