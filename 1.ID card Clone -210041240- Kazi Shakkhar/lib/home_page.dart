import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ID Card Demo')),
      body: Center(
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
                // Background sections
                Column(
                  children: [
                    // Top Green
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(4, 69, 14, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // University Logo
                            SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset(
                                'assets/iutlogo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // University Name
                            SizedBox(
                              width: double.infinity,
                              child: AutoSizeText(
                                'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Helvetica Bold',
                                ),
                                minFontSize: 8,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Middle White
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Student ID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.key, size: 14, color: Colors.black),
                                SizedBox(width: 8),
                                Text('Student ID'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(4, 69, 14, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.circle,
                                        size: 14,
                                        color: Color.fromARGB(255, 99, 122, 237),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '210041240',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Student Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.account_circle, size: 14, color: Colors.black),
                                SizedBox(width: 8),
                                Text('Student Name'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 8),
                                Text(
                                  'Kazi Shakkhar Rahman',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            // Program
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.school, size: 14, color: Colors.black),
                                SizedBox(width: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Program '),
                                      TextSpan(
                                        text: 'BSc in CSE',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Department
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.group, size: 14, color: Colors.black),
                                SizedBox(width: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Department: '),
                                      TextSpan(
                                        text: 'CSE',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Country
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.location_pin, size: 14, color: Colors.black),
                                SizedBox(width: 8),
                                Text('Bangladesh'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Green
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(4, 69, 14, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'A subsidiary organ of OIC',
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Student Photo
                Positioned(
                  top: 100,
                  left: 60,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(4, 69, 14, 1), // dark green border
                        width: 5, // slightly wider
                      ),
                      // no borderRadius → full rectangle
                    ),
                    child: Image.asset(
                      'assets/student.png',
                      fit: BoxFit.cover,
                    ),
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
