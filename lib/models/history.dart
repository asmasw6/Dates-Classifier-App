//import 'dart:typed_data';

class History {
  final int? id;
  final String prediction;
  final String confidence;
  final String date;
  final String  image; // store as bytes

  History({
    this.id,
    required this.prediction,
    required this.confidence,
    required this.date,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prediction': prediction,
      'confidence': confidence,
      'date': date,
      'image': image, // blob
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      prediction: map['prediction'],
      confidence: map['confidence'],
      date: map['date'],
      image: map['image'],
    );
  }
}
