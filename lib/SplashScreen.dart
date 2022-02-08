// ignore_for_file: file_names, always_use_package_imports

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/constants.dart';
import 'screens/BottomNavBar.dart';

class MyCustomSplashScreen extends StatefulWidget {
  @override
  _MyCustomSplashScreenState createState() => _MyCustomSplashScreenState();
}

class _MyCustomSplashScreenState extends State with TickerProviderStateMixin {
  double _fontSize = 2.0;
  int _containerSize = 1;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  Animation? animation1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween(begin: 40, end: 20).animate(CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(const Duration(seconds: 4), () {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(duration: const Duration(milliseconds: 2000), curve: Curves.fastLinearToSlowEaseIn, height: Get.size.height / _fontSize),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: const Text(
                  'SHARAFYABI',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontFamily: montserratBold,
                    // fontSize: animation1!.value,
                    fontSize: 26,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: Get.size.width / _containerSize,
                  width: Get.size.width / _containerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/appLogo/greyLogo.png', color: kPrimaryColor)
                  // child: const Text(
                  //   'YOUR APP\'S LOGO',
                  // ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
