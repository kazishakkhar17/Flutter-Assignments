import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/hacker_news_api.dart';
import 'package:flutter_html/flutter_html.dart'; // optional to render HTML in comments

class NewsDetailScreen extends StatefulWidget {
  final Story story;
  const NewsDetailScreen({super.key, required this.story});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  List<String> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    if (widget.story.kids == null || widget.story.kids!.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final topCommentIds = widget.story.kids!.take(10); // limit to top 10 comments
    List<String> fetchedComments = [];

    for (var id in topCommentIds) {
      final text = await HackerNewsApi.fetchCommentText(id);
      if (text != null) fetchedComments.add(text);
    }

    setState(() {
      comments = fetchedComments;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Detail')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.story.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('By ${widget.story.by}', style: const TextStyle(color: Colors.grey)),
                if (widget.story.score != null) Text('Score: ${widget.story.score}'),
                const SizedBox(height: 12),
                const Text('Top Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Html(data: comments[index]), // render HTML safely
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
