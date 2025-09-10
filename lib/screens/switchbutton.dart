import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// https://dates-classification.onrender.com/predict
class Switchbutton extends StatefulWidget {
  const Switchbutton({super.key});

  @override
  State<Switchbutton> createState() => _SwitchbuttonState();
}

class _SwitchbuttonState extends State<Switchbutton> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent), 
              indicator: BoxDecoration(
                color: const Color.fromRGBO(152, 251, 152, 1)
                    .withValues(alpha: 0.2), // background for active tab
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.green, // text color when selected
              tabs: [
                Tab(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Color.fromARGB(255, 51, 138, 53),
                  ),
                  child: Text(
                    "مُصنف",
                    style: GoogleFonts.beiruti(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  icon: const Icon(
                    Icons.sticky_note_2_outlined,
                    color: Color.fromARGB(255, 51, 138, 53),
                  ),
                  child: Text(
                    "سجلات",
                    style: GoogleFonts.beiruti(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            title: Center(
              child: Text('مُصنف التمور🌴',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.elMessiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text("This is Page 1")),
              Center(child: Text("This is Page 2")),
            ],
          ),
        ));
  }
}
