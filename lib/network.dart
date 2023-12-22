import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/data.dart';

Future<List<Question>> fetchQuiz() async {
  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/worldline/learning-kotlin-multiplatform/main/quiz.json'));

  if (response.statusCode == 200) {
    // If the server returned a 200 OK response, parse the JSON
    return Quiz.fromJson(jsonDecode(response.body) as Map<String, dynamic>).questions;
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load quiz');
  }
}