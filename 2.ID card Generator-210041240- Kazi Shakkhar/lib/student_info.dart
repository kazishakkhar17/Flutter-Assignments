import 'dart:typed_data';
class StudentInfo {
  final String id;
  final String name;
  final String program;
  final String department;
  final String country;
  final String? photoPath;     // <-- allow null
  final Uint8List? photoBytes; // <-- for web

  StudentInfo({
    required this.id,
    required this.name,
    required this.program,
    required this.department,
    required this.country,
    this.photoPath,
    this.photoBytes,
  });
}
