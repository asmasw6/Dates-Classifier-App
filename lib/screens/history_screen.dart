import 'package:flutter/material.dart';

import 'dart:io'; // NEW (عشان نعرض الصور من File)
import 'package:dates_classifier/services/database_service.dart'; // NEW
import 'package:dates_classifier/models/history.dart'; // NEW

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Example history list
  // final List<Map<String, String>> data = [   // OLD
  //   {"image": "images", "date": "2025/09/10", "predection": "95 %"},
  //   {"image": "images2", "date": "2025/09/11" , "predection": "95 %"},
  // ];

  List<History> data = []; // NEW بدل المابس

  @override
  void initState() {
    super.initState();
    _loadHistory(); // NEW
  }

  Future<void> _loadHistory() async {
    // NEW
    final db = DatabaseService.instance;
    final histories = await db.getHistories();
    setState(() {
      data = histories ?? [];
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
      const SnackBar(content: Text("Item deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;

    return data == null
    ?const Center(child: Text("لا يوجد سجلات بعد" ))
    :ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Dismissible(
              key: ValueKey(item.id), // unique key
              direction: DismissDirection.endToStart, // swipe right-to-left
              background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red, // <-- Add a background color
                    borderRadius:
                        BorderRadius.circular(10), // <-- Use BoxDecoration here
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
                  data.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$item deleted")),
                );
              },
              child: Card(
                color: Colors.white,
                elevation: 2, // 👈 قوة الظل (جرب من 2 إلى 10)
                shadowColor: Colors.grey.withOpacity(0.5), // 👈 لون الظل
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // 👈 يعطي زوايا دائرية
                ),

                child: ListTile(
                  minTileHeight: screenHeight * .02,
                  leading: item.image != null // NEW
                      ? SizedBox(
                          width: 60,
                          height: 100,
                          child: ClipOval(
                            child: Image.file(
                              File(item.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(Icons.image), // NEW fallbac
                  //Image(image: AssetImage(item['image']!)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range,
                              size: 20, color: Colors.green[500]),
                          SizedBox(width: 5),
                          Text(item.date),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.class_outlined,
                              size: 20, color: Colors.green[500]),
                          SizedBox(width: 5),
                          Text(item.prediction),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 20, color: Colors.green[500]),
                          SizedBox(width: 5),
                          Text(item.confidence),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
