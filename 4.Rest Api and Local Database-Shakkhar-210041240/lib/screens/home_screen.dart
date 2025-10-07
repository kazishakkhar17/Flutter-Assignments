import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/story_provider.dart';
import 'news_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final state = ref.read(storyProvider);
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !state.isLoading) {
        ref.read(storyProvider.notifier).fetchNextChunk();
      }
    });
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: ListTile(
              title: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              subtitle: Container(
                height: 14,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // subtle background
appBar: AppBar(
  title: const Text('Hacker News'),
  backgroundColor: Colors.grey[800], // changed from orange[800] to gray
  elevation: 4,
  shadowColor: Colors.grey[500], // changed from orangeAccent to gray
  actions: [
    TextButton(
      onPressed: () => ref.read(storyProvider.notifier)
          .fetchInitialStories('topstories'),
      child: const Text('Top', style: TextStyle(color: Colors.white)),
    ),
    TextButton(
      onPressed: () => ref.read(storyProvider.notifier)
          .fetchInitialStories('beststories'),
      child: const Text('Best', style: TextStyle(color: Colors.white)),
    ),
    TextButton(
      onPressed: () => ref.read(storyProvider.notifier)
          .fetchInitialStories('newstories'),
      child: const Text('New', style: TextStyle(color: Colors.white)),
    ),
  ],
),

      body: state.stories.isEmpty && state.isLoading
          ? _buildShimmer()
          : ListView.builder(
              controller: _controller,
              itemCount: state.stories.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.stories.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final story = state.stories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    color: Colors.white,
                    shadowColor: Colors.orangeAccent,
                    child: ListTile(
                      title: Text(
                        story.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'By ${story.by}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(story: story),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
