import 'dart:io';
import 'package:dates_classifier/services/database_service.dart';
import 'package:dates_classifier/services/prediction_service.dart';
import 'package:dates_classifier/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // لعرض التاريخ بشكل مرتب


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

      String prediction = result['class'];
      String confidence = result['confidence'];

      // 🔹 تخزين في قاعدة البيانات
      String now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
      await databaseService.insertHistory(
        prediction: prediction,
        confidence: confidence,
        date: now,
        imagePath: pickedFile.path,
      );

        /// 🔹 هنا تشغل الموديل (استبدلها باستدعاء الموديل الحقيقي)
        await Future.delayed(const Duration(seconds: 2));
        //String predictionFacke = "Ajwa Dates 🌴"; // مثال تصنيف من الموديل
        //String confidenceFacke = "95%"; // مثال تصنيف من الموديل

       

        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _result = "$prediction Dates\nAccurcy: $confidence";
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

    /// double screenWidth = MediaQuery.of(context).size.width;

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
              ? const Center(child: CircularProgressIndicator())
              : _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      height: 240,
                      width: 240,
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
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),

        SizedBox(
          height: screenHeight * .066,
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


/*
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Simulate prediction delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _result = "This looks like Ajwa Dates 🌴"; // Example result
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  */