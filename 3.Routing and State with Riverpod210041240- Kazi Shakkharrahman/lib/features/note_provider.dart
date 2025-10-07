import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'note_model.dart';
import 'package:collection/collection.dart'; // for firstWhereOrNull

final notesProvider =
    StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<Note>> {
  late Box<Note> _notesBox;
  bool isLoading = true;

  NotesNotifier() : super([]) {
    _init();
  }

  // Initialize Hive box
  Future<void> _init() async {
    _notesBox = await Hive.openBox<Note>('notesBox');
    state = _notesBox.values.toList();
    isLoading = false;
  }

  // Get a note by ID safely
  Note? getNoteById(String id) {
    if (isLoading) return null;
    return state.firstWhereOrNull((n) => n.id == id);
  }

  // Add a new note
  Future<void> add(String content) async {
    if (isLoading) return;
    final note = Note(id: DateTime.now().toString(), content: content);
    await _notesBox.add(note);
    state = [...state, note];
  }

  // Delete a note
  Future<void> delete(String id) async {
    if (isLoading) return;
    final note = state.firstWhere((n) => n.id == id);
    await note.delete();
    state = state.where((n) => n.id != id).toList();
  }

  // Edit a note
  Future<void> edit(String id, String newContent) async {
    if (isLoading) return;
    final note = state.firstWhere((n) => n.id == id);
    note.content = newContent;
    await note.save();
    state = [
      for (final n in state)
        if (n.id == id) note else n,
    ];
  }
}
