import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  Button(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  final IconData? icon; // make it final
  final String text;
  final Future<void> Function()?  onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(150, 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.white,
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: GoogleFonts.beiruti(
          fontSize: 26,
          color: Colors.black,
        ),
      ),
      icon: Icon(
        icon,
        color: const Color.fromARGB(255, 51, 138, 53),
      ),
    );
  }
}
