import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class RowLabel extends StatelessWidget {
  RowLabel({super.key, required this.icon, required this.text});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green[500]),
        SizedBox(width: 5),
        Text(
        text,
        style: GoogleFonts.beiruti(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      ],
    );
  }
}
