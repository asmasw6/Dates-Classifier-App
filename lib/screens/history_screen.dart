import 'package:dates_classifier/widgets/history_card.dart';
import 'package:dates_classifier/widgets/row_label.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:dates_classifier/services/database_service.dart';
import 'package:dates_classifier/models/history.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> data = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = DatabaseService.instance;
    final histories = await db.getHistories();
    if (!mounted) return; // <- make sure widget is still alive

    setState(() {
      data = histories;
    });
  }

  Future<void> _deleteHistory(int id, int index) async {
    // NEW
    final db = DatabaseService.instance;
    await db.deleteHistory(id);
    setState(() {
      data.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم حذف العنصر بنجاح 👍"),
        backgroundColor: Colors.green[500],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;

    return data.isEmpty
        ? Center(
            child: Text(
            "❎ قائمة السجلات فارغة  ",
            style: GoogleFonts.beiruti(
              fontSize: 20,
              color: Colors.black,
            ),
          ))
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Dismissible(
                      key: ValueKey(item.id), // unique key
                      direction:
                          DismissDirection.endToStart, // swipe right-to-left
                      background: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.red[500], // <-- Add a background color
                            borderRadius: BorderRadius.circular(
                                10), // <-- Use BoxDecoration here
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )),
                      onDismissed: (direction) {
                        setState(() {
                          _deleteHistory(item.id!, index);
                          data.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$item deleted")),
                        );
                      },
                      child: HistoryCard(dataItem: item)));
            },
          );
  }
}
