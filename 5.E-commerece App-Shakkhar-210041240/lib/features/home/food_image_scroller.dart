import 'package:flutter/material.dart';
import 'dart:async';

class FoodImageScroller extends StatefulWidget {
  const FoodImageScroller({super.key});

  @override
  State<FoodImageScroller> createState() => _FoodImageScrollerState();
}

class _FoodImageScrollerState extends State<FoodImageScroller> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _images = [
    'assets/images/food1.png',
    'assets/images/food2.png',
    'assets/images/food3.png',
    'assets/images/food4.png',
    'assets/images/food5.png',
  ];

  double _scrollPosition = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _scrollPosition += 1;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollPosition);
        if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
          _scrollPosition = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image.asset(
            _images[index],
            width: 120,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
