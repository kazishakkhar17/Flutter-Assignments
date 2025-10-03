import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'student_info.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  String id = "";
  String name = "";
  String program = "";
  String department = "";
  String country = "";

  File? pickedImageFile; // for mobile
  Uint8List? pickedImageBytes; // for web

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          pickedImageBytes = bytes;
        });
      } else {
        setState(() {
          pickedImageFile = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Student Info")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input fields
              TextFormField(
                decoration: const InputDecoration(labelText: "Student ID"),
                onChanged: (v) => id = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (v) => name = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Program"),
                onChanged: (v) => program = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Department"),
                onChanged: (v) => department = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Country"),
                onChanged: (v) => country = v,
              ),
              const SizedBox(height: 20),

              // Pick image button + preview
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text("Pick Photo"),
                  ),
                  const SizedBox(width: 12),
                  if (pickedImageBytes != null)
                    Image.memory(
                      pickedImageBytes!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  else if (pickedImageFile != null)
                    Image.file(
                      pickedImageFile!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text("No photo selected"),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Generate ID Card"),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/idcard',
                    arguments: StudentInfo(
                      id: id,
                      name: name,
                      program: program,
                      department: department,
                      country: country,
                      photoPath: pickedImageFile
                          ?.path, // ok now, because String? is allowed
                      photoBytes: pickedImageBytes, // for web
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
