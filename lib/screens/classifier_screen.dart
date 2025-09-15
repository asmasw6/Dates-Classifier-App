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
  bool _isPicking = false;
  final DatabaseService databaseService = DatabaseService.instance;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return; // prevent multiple pickers
    _isPicking = true;

    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isLoading = true;
          _result = null;
        });

        // 🔹 Invock PredictionService
        var result = await PredictionService.predictDate(File(pickedFile.path));
        String prediction = toArabic(result['class']);
        String confidence = result['confidence'];

        // 🔹 Store in database
        String now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
        await databaseService.insertHistory(
          prediction: prediction,
          confidence: confidence,
          date: now,
          imagePath: pickedFile.path,
        );

        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _result = "التصنيف: $prediction\nنسبة الثقة: $confidence";
        });
      }
    } finally {
      _isPicking = false; // reset whether success or fail
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Image container
        Container(
          width: double.infinity,
          height: screenHeight * .43,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.green[40],
          ),
          child: _imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 70,
                  color: Colors.green[200],
                )),
        ),
        const SizedBox(height: 16),

        // Result Section
        _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green[500],
                ),
              )
            : _result != null
                ? Text(
                    _result!,
                    style: GoogleFonts.beiruti(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  )
                : const SizedBox(),

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
