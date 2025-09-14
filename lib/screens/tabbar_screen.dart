import 'package:dates_classifier/screens/classifier_screen.dart';
import 'package:dates_classifier/screens/history_screen.dart';
import 'package:dates_classifier/services/database_service.dart';
import 'package:dates_classifier/widgets/top_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final DatabaseService databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
              tabs: const [
                TopTab(
                  text: "مُصنف",
                  icon: Icons.camera_alt_outlined,
                ),
                TopTab(
                  text: "سجلات",
                  icon: Icons.sticky_note_2_outlined,
                )
              ],
                indicatorColor: Colors.green[600], // change the grey line to green
                indicatorWeight: 4.0, // height of the line
            ),
            title: Center(
              child: Text('🌴مُصنف التمور',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.elMessiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                      horizontal: screenWidth * .06,
                      vertical: screenHeight * .04),
                  child: const ClassifierScreen(),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                      horizontal: screenWidth * .06,
                      vertical: screenHeight * .04),
                  child: const HistoryScreen(),
                ),
              ),
            ],
          ),
        ));
  }
}
