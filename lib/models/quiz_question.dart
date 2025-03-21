class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromList(List<dynamic> data) {
    // Convertir data[5] en int si c'est une chaîne, sinon l'utiliser directement
    int correctAnswer = data[5] is String ? int.parse(data[5]) : data[5];
    
    return QuizQuestion(
      question: data[0],
      options: [data[1], data[2], data[3], data[4]],
      correctAnswerIndex: correctAnswer - 1,
    );
  }
}