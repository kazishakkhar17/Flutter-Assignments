import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/note_page.dart';
import '../features/note_edit_page.dart';
import '../features/settings_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotePage(),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
final id = state.pathParameters['id']!;

        return NoteEditPage(noteId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
