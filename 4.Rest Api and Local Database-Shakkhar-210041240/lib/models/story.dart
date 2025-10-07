// models/story.dart
class Story {
  final int id;
  final String title;
  final String by;
  final String? url;
  final int? score;
  final int? time;
  final List<int>? kids;

  Story({
    required this.id,
    required this.title,
    required this.by,
    this.url,
    this.score,
    this.time,
    this.kids,
  });

  // From API
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      by: json['by'] ?? 'Unknown',
      url: json['url'],
      score: json['score'],
      time: json['time'],
      kids: json['kids'] != null ? List<int>.from(json['kids']) : null,
    );
  }

  // To DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'url': url,
      'score': score,
      'time': time,
      'kids': kids?.join(','), // store list as CSV
    };
  }

  // From DB
  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'],
      title: map['title'],
      by: map['by'],
      url: map['url'],
      score: map['score'],
      time: map['time'],
      kids: map['kids'] != null
          ? (map['kids'] as String).split(',').map((e) => int.parse(e)).toList()
          : null,
    );
  }
}
