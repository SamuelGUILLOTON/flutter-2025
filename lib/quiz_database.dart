import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, instantiate it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'quiz.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        try {
          await db.execute('''
        CREATE TABLE questions (
          id INTEGER PRIMARY KEY,
          label TEXT NOT NULL,
          correctAnswerId INTEGER NOT NULL
        )
      ''');

          // Create the 'answers' table
          await db.execute('''
        CREATE TABLE answers (
          id INTEGER,
          label TEXT NOT NULL,
          question_id INTEGER NOT NULL,
          PRIMARY KEY (id, question_id),
          FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
        )
      ''');
        } catch (e) {
          // Handle database creation errors
          print('Error during database creation: $e');
          // Log or display the error as needed
        }
        await db.close();
      },
    );

  }

  Future<void> insertQuestionsWithAnswers(List<Question> questions) async {
    Database db = await database; // Assuming 'database' is your SQLite database instance

    await db.transaction((txn) async {
      for (var question in questions) {
        int questionId = await txn.rawInsert(
          'INSERT INTO questions (label, correctAnswerId) VALUES (?, ?)',
          [question.label, question.correctAnswerId],
        );

        for (var answer in question.answers) {
          await txn.rawInsert(
            'INSERT INTO answers (id, label, question_id) VALUES (?, ?, ?)',
            [answer.id, answer.label, questionId],
          );
        }
      }
    });
    await db.close();
  }


  Future<List<Question>> getQuestionsWithAnswers() async {
    Database db = await database;
    List<Map<String, dynamic>> questionMaps = await db.rawQuery('''
    SELECT questions.id AS id, questions.label AS label, questions.correctAnswerId AS correctAnswerId, answers.id AS answer_id, answers.label AS answer_label 
    FROM questions
    INNER JOIN answers ON questions.id = answers.question_id
  ''');

    Map<int, Question> questionMap = {};

    for (var questionMapData in questionMaps) {
      final questionId = questionMapData['id'] as int;
      final answerId = questionMapData['answer_id'] as int; // Assuming answer ID is prefixed with 'answers.'
      final answerLabel = questionMapData['answer_label'] as String; // Assuming answer label is prefixed with 'answers.'

      if (!questionMap.containsKey(questionId)) {
        questionMap[questionId] = Question.fromMap(questionMapData);
        questionMap[questionId]!.answers = [];
      }

      // Adding answers to respective questions
      questionMap[questionId]!.answers.add(Answer(id: answerId, label: answerLabel));
    }

    await db.close();

    return questionMap.values.toList();
  }

  Future<void> deleteQuestions() async {
    Database db = await database;
    await db.rawDelete('DELETE FROM questions');
    await db.close();
  }

  Future<void> deleteAnswers() async {
    Database db = await database;
    await db.rawDelete('DELETE FROM answers');
    await db.close();
  }
}