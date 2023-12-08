class Quiz {
  List<Question> questions;
  Quiz({required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<Question> questions = (json['questions'] as List)
        .map((question) => Question.fromJson(question))
        .toList();

    return Quiz(questions: questions);
  }
}

class Question {
  int id;
  String label;
  int correctAnswerId;
  List<Answer> answers;

  Question({
    required this.id,
    required this.label,
    required this.correctAnswerId,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = (json['answers'] as List)
        .map((answer) => Answer.fromJson(answer))
        .toList();

    return Question(
      id: json['id'],
      label: json['label'],
      correctAnswerId: json['correct_answer_id'],
      answers: answers,
    );
  }
}

class Answer {
  int id;
  String label;

  Answer({
    required this.id,
    required this.label,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      label: json['label'],
    );
  }
}
