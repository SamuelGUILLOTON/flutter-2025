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
    return QuizQuestion(
      question: data[0],
      options: [data[1], data[2], data[3], data[4]],
      correctAnswerIndex: int.parse(data[5]) - 1,
    );
  }
}