import 'dart:io';
import 'package:dates_classifier/services/database_service.dart';
import 'package:dates_classifier/services/prediction_service.dart';
import 'package:dates_classifier/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


class ClassifierScreen extends StatefulWidget {
  const ClassifierScreen({super.key});

  @override
  State<ClassifierScreen> createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  File? _imageFile;
  bool _isLoading = false;
  String? _result;
  bool _isPicking = false; // add this at class level
  final DatabaseService databaseService = DatabaseService.instance;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return; // prevent multiple pickers
    _isPicking = true;

    final Map<String, String> dateTranslations = {
  "Ajwa": "عجوة",
  "Galaxy": "جالكسي",
  "Medjool": "مجدول",
  "Meneifi": "منيفي",
  "Nabtat Ali": "نبتة علي",
  "Rutab": "رطب",
  "Shaishe": "شيشة",
  "Sokari": "سكري",
  "Sugaey": "صقعي",
};

String toArabic(String englishName) {
  return dateTranslations[englishName] ?? englishName;
}


    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      //         _result = "This looks like Ajwa Dates 🌴"; // Example result

      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // 🔹 استدعاء PredictionService
        var result = await PredictionService.predictDate(File(pickedFile.path));

        String prediction = toArabic(result['class']);
        String confidence = result['confidence'];

        // 🔹 تخزين في قاعدة البيانات
        String now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
        await databaseService.insertHistory(
          prediction: prediction,
          confidence: confidence,
          date: now,
          imagePath: pickedFile.path,
        );

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _result = "التصنيف: $prediction\nنسبة الثقة: $confidence";
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } finally {
      _isPicking = false; // reset whether success or fail
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Image container
        Container(
          width: double.infinity,
          height: screenHeight * .45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(12),
            color: Colors.green[40],
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.green[500],
                ))
              : _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      height: screenHeight * .1, // 240
                      width: screenWidth * .1,
                    )
                  : Center(
                      child: Icon(
                      Icons.add_a_photo_rounded,
                      size: 70,
                      color: Colors.green[200],
                    )),
        ),
        const SizedBox(height: 16),

        // Result
        if (_result != null)
          Text(
            _result!,
            style: GoogleFonts.beiruti(
              fontSize: 24,
              fontWeight: FontWeight.bold, color: Colors.green[600],
            )
          ),

        SizedBox(
          height: screenHeight * .03,
        ),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              icon: Icons.photo,
              text: "حمّل",
              onPressed:
                  _isPicking ? null : () => _pickImage(ImageSource.gallery),
            ),
            Button(
              icon: Icons.camera_alt,
              text: "كاميرا",
              onPressed:
                  _isPicking ? null : () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ],
    );
  }
}
