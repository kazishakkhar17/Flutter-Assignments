// providers/story_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import '../services/hacker_news_api.dart';
import '../services/db.dart' as db; // prefix to avoid conflicts
import 'package:flutter_riverpod/legacy.dart';


class StoryState {
  final bool isLoading;
  final List<Story> stories;
  final String currentType;
  final List<int> allIds;
  final int nextIndex;

  StoryState({
    required this.isLoading,
    required this.stories,
    required this.currentType,
    required this.allIds,
    required this.nextIndex,
  });

  StoryState copyWith({
    bool? isLoading,
    List<Story>? stories,
    String? currentType,
    List<int>? allIds,
    int? nextIndex,
  }) {
    return StoryState(
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      currentType: currentType ?? this.currentType,
      allIds: allIds ?? this.allIds,
      nextIndex: nextIndex ?? this.nextIndex,
    );
  }
}

class StoryNotifier extends StateNotifier<StoryState> {
  static const int chunkSize = 20;

  StoryNotifier()
      : super(StoryState(
          isLoading: false,
          stories: [],
          currentType: 'topstories',
          allIds: [],
          nextIndex: 0,
        )) {
    fetchInitialStories('topstories');
  }

  Future<void> fetchInitialStories(String type) async {
    state = state.copyWith(isLoading: true, stories: [], nextIndex: 0, currentType: type);

    try {
      // Load cached stories first
      final cachedStories = await db.AppDatabase.instance.getStories();
      if (cachedStories.isNotEmpty) {
        final storiesList = cachedStories.map((e) => Story.fromMap(e)).toList();
        state = state.copyWith(
          stories: storiesList,
          nextIndex: storiesList.length,
          isLoading: false,
        );
      }

      // Fetch fresh IDs from API
      final allIds = await HackerNewsApi.fetchStoryIds(type);
      state = state.copyWith(allIds: allIds);

      await fetchNextChunk();
    } catch (e) {
      print('Error fetching stories: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchNextChunk() async {
    if (state.nextIndex >= state.allIds.length) return;

    state = state.copyWith(isLoading: true);

    final endIndex = (state.nextIndex + chunkSize) > state.allIds.length
        ? state.allIds.length
        : state.nextIndex + chunkSize;

    final idsToFetch = state.allIds.sublist(state.nextIndex, endIndex);

    // Fetch stories concurrently
    final futures = idsToFetch.map((id) => HackerNewsApi.fetchStoryById(id));
    final results = await Future.wait(futures);
    final fetchedStories = results.whereType<Story>().toList();

    // Save chunk to DB
    final storiesMap = fetchedStories.map((e) => e.toMap()).toList();
    await db.AppDatabase.instance.saveStories(storiesMap);

    state = state.copyWith(
      stories: [...state.stories, ...fetchedStories],
      nextIndex: endIndex,
      isLoading: false,
    );
  }
}

// Provider
final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) => StoryNotifier());
