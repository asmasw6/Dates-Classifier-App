import 'package:dates_classifier/screens/tabbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class LoaderUi extends StatefulWidget {
  const LoaderUi({super.key});

  @override
  State<LoaderUi> createState() => _LoaderUiState();
}

class _LoaderUiState extends State<LoaderUi>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabBarScreen()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
        super.dispose();
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/loader/Datepalm3.gif',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          Text(
            "مُصنف التمور",
            style: GoogleFonts.elMessiri(
              color: const Color.fromARGB(255, 101, 50, 14),
              //Color.fromRGBO(139, 69, 19, 1),
              fontSize: 50,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      )),
      backgroundColor: Color.fromRGBO(152, 251, 152, 1),
    );
  }
}

// https://app.lottiefiles.com/animation/25abf90e-85c5-451d-a986-b05551fdf413?channel=web&from=download&panel=download&source=public-animation
