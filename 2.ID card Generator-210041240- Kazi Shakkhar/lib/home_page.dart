import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color bgColor = const Color.fromRGBO(4, 69, 14, 1); // initial deep green

  // List of fonts to choose from
  final List<String> fontFamilies = [
    'Roboto',
    'Lobster',
    'Pacifico',
    'Oswald',
    'Anton',
    'Poppins',
    'Merriweather',
  ];

  String currentFont = 'Roboto'; // default font

  // Change background color randomly
  void changeColor() {
    setState(() {
      bgColor = Color.fromRGBO(
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
        1,
      );
    });
  }

  // Change font randomly
  void changeFont() {
    setState(() {
      currentFont = fontFamilies[Random().nextInt(fontFamilies.length)];
    });
  }

  // Helper to generate safe TextStyle for TextSpan
  TextStyle spanStyle({double fontSize = 14, FontWeight? fontWeight, Color? color}) {
    return GoogleFonts.getFont(
      currentFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ID Card Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 220,
                height: 400,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        // Top Section
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/iutlogo.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                    'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: GoogleFonts.getFont(
                                      currentFont,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Middle White Section
                        Expanded(
                          flex: 6,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.key, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Student ID ',
                                      style: GoogleFonts.getFont(currentFont, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.circle, size: 14, color: Color.fromARGB(255, 99, 122, 237)),
                                          const SizedBox(width: 8),
                                          Text(
                                            '210041240',
                                            style: GoogleFonts.getFont(
                                              currentFont,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Student Name',
                                      style: GoogleFonts.getFont(currentFont, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Kazi Shakkhar Rahman',
                                      style: GoogleFonts.getFont(currentFont, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.school, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'Program ', style: spanStyle(fontSize: 14)),
                                          TextSpan(text: 'BSc in CSE', style: spanStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.apartment, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'Department: ', style: spanStyle(fontSize: 14)),
                                          TextSpan(text: 'CSE', style: spanStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text('Bangladesh', style: spanStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Section
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'A subsidiary organ of OIC',
                                style: spanStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Floating Photo
                    Positioned(
                      top: 100,
                      left: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Image.asset('assets/student.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: changeColor, child: const Text("Change Background Color")),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: changeFont, child: const Text("Change Font")),
        ],
      ),
    );
  }
}
