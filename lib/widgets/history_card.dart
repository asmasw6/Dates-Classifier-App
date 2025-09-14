import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dates_classifier/models/history.dart';
import 'package:dates_classifier/widgets/row_label.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.dataItem,
  }) : super(key: key);
  final History dataItem;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        minTileHeight: screenHeight * .02,
        leading: SizedBox(
          width: 60,
          height: 100,
          child: ClipOval(
            child: Image.file(
              File(dataItem.image),
              fit: BoxFit.cover,
            ),
          ),
        ), // NEW fallbac
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowLabel(
              icon: Icons.date_range,
              text: dataItem.date,
            ),
            RowLabel(icon: Icons.category_outlined, text: dataItem.prediction),
            RowLabel(
                icon: Icons.signal_cellular_alt, text: dataItem.confidence),
          ],
        ),
      ),
    );
  }
}
