import 'package:flutter/material.dart';
import 'package:quiz/data.dart';
import 'package:quiz/score_screen.dart';
import 'package:quiz/network.dart';


class QuestionScreen extends StatefulWidget {
  //final List<Question> questions;

  //const QuestionScreen({Key? key, required this.questions}) : super(key: key);
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {

  late Future<List<Question>> _quizFuture; // Declare a Future variable

  @override
  void initState() {
    super.initState();
    _quizFuture = fetchQuiz(); // Call fetchQuiz() in initState to fetch data
  }


  int questionProgress = 0;
  int selectedAnswer = 1;
  int score = 0;

  void _nextOrDone(List<Question> questions) {
    if (selectedAnswer == questions[questionProgress].correctAnswerId) {
      setState(() {
        score++;
      });
    }
    if (questionProgress < questions.length - 1) {
      setState(() {
        questionProgress++;
        selectedAnswer = 1;
      });
    } else {
      Navigator.pushNamed(
        context,
        "/Score",
        arguments: ScoreScreenArguments(
            '$score/${questions.length}',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: _quizFuture, // Call the fetchQuiz function here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
             body: Center(
                  child: CircularProgressIndicator()
              ),
        );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: const EdgeInsets.all(60.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        snapshot.data![questionProgress].label,
                        style: const TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data![questionProgress].answers
                        .map(
                          (answer) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: answer.id,
                                  groupValue: selectedAnswer,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswer = value as int;
                                    });
                                  },
                                ),
                                const SizedBox(
                                    width:
                                        8), // Adjust the spacing here if needed
                                Text(
                                  answer.label,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {_nextOrDone(snapshot.data!);},
              child: questionProgress < snapshot.data!.length - 1
                  ? const Icon(Icons.arrow_forward)
                  : const Icon(Icons.done),
            ),
            bottomNavigationBar: LinearProgressIndicator(
              value: (questionProgress + 1) / snapshot.data!.length,
              minHeight: 20.0,
            ),
          );
        }
      },
    );
  }
}
