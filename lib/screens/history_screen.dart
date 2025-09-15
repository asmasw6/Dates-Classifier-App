import 'package:dates_classifier/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:dates_classifier/services/database_service.dart';
import 'package:dates_classifier/models/history.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseService databaseService = DatabaseService.instance;
  List<History> data = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final histories = await databaseService.getHistories();
    if (!mounted) return; // <- make sure widget is still alive

    setState(() {
      data = histories;
    });
  }

  Future<void> _deleteHistory(int id, int index) async {
    // NEW
    await databaseService.deleteHistory(id);
    setState(() {
      data.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم حذف العنصر بنجاح 👍",
          style: GoogleFonts.beiruti(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: Text(
            "❎ قائمة السجلات فارغة ",
            style: GoogleFonts.beiruti(
              fontSize: 20,
              color: Colors.black,
            ),
          ))
        : ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(Colors.green), // اللون أخضر
              //trackColor: MaterialStateProperty.all(Colors.green[100]),
              //thickness: MaterialStateProperty.all(10), // العرض
              radius: const Radius.circular(8),
              crossAxisMargin: 2, // المسافة بين السكول بار والبلدر
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true, //
              thickness: 4, //
              radius: const Radius.circular(8),
              //trackVisibility: true,
              interactive: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
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
                          _deleteHistory(item.id!, index);
                        },
                        child: HistoryCard(dataItem: item),
                      ),
                    );
                  },
                ),
              ),
            ));
  }
}
