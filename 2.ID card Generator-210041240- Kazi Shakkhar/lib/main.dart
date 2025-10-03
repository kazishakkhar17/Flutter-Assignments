import 'package:flutter/material.dart';
import 'form.dart';
import 'idcard.dart';
import 'student_info.dart';

void main() {
  runApp(MyApp()); // removed const here
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ID Card Generator',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => StudentFormPage(), // StatefulWidget, cannot be const
        '/idcard': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as StudentInfo;
          return IDCardPage(student: args); // runtime data, no const
        },
      },
    );
  }
}
