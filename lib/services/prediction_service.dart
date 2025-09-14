import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionService {
static final PredictionService instance = PredictionService._internal();
  PredictionService._internal();

  static const String apiUrl = "https://dates-classification.onrender.com/predict";

  /// Send image to API and get prediction + confidence
  static Future<Map<String, dynamic>> predictDate(File imageFile) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      // Attach image
      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile.path),
      );

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decoded = jsonDecode(responseData);

        return decoded; // e.g. {"prediction": "Sukkari", "confidence": 0.95}
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Prediction failed: $e");
    }
  }
}
