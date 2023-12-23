import 'data.dart';

  Future<List<Question>> generateDummyQuestionsList() async {
    return generateQuestionsList();
  }

  List<Question> generateQuestionsList() {
    return [
      Question(
        id: 1,
        label: "What does HTTP stand for in the context of networking?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "HyperText Transfer Protocol"),
          Answer(id: 2, label: "High Tech Transfer Protocol"),
          Answer(id: 3, label: "Hyper Transfer Protocol"),
          Answer(id: 4, label: "Highway Transfer Protocol"),
        ],
      ),
      Question(
        id: 2,
        label: "Which package is commonly used for making HTTP requests in Flutter?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "http"),
          Answer(id: 2, label: "network"),
          Answer(id: 3, label: "dart.io"),
          Answer(id: 4, label: "internet"),
        ],
      ),
      Question(
        id: 3,
        label: "What does the 'async' keyword indicate in a function signature?",
        correctAnswerId: 2,
        answers: [
          Answer(id: 1, label: "The function runs asynchronously"),
          Answer(id: 2, label: "The function is asynchronous"),
          Answer(id: 3, label: "The function is a callback"),
          Answer(id: 4, label: "The function runs synchronously"),
        ],
      ),
      Question(
        id: 4,
        label: "Which method is used to perform a GET request in the 'http' package?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "http.get()"),
          Answer(id: 2, label: "http.request()"),
          Answer(id: 3, label: "http.sendRequest()"),
          Answer(id: 4, label: "http.fetch()"),
        ],
      ),
      Question(
        id: 5,
        label: "What does the 'Future' class represent in Dart?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "A potential value or error that will be available in the future"),
          Answer(id: 2, label: "An immediate value"),
          Answer(id: 3, label: "A static value"),
          Answer(id: 4, label: "An asynchronous function"),
        ],
      ),
      Question(
        id: 6,
        label: "What is the purpose of the 'async' and 'await' keywords?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "To work with asynchronous code in a synchronous manner"),
          Answer(id: 2, label: "To make code execution slower"),
          Answer(id: 3, label: "To convert synchronous code to asynchronous"),
          Answer(id: 4, label: "To block code execution"),
        ],
      ),
      Question(
        id: 7,
        label: "What does the 'then' method do when used with a Future in Dart?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "It registers a callback to be called when the Future completes"),
          Answer(id: 2, label: "It cancels the Future"),
          Answer(id: 3, label: "It waits indefinitely for the Future to complete"),
          Answer(id: 4, label: "It synchronously returns the Future's value"),
        ],
      ),
      Question(
        id: 8,
        label: "Which HTTP status code represents a successful response?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "200"),
          Answer(id: 2, label: "404"),
          Answer(id: 3, label: "500"),
          Answer(id: 4, label: "301"),
        ],
      ),
      Question(
        id: 9,
        label: "What is the purpose of the 'catchError' method with a Future?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "To handle errors that occur during the Future's execution"),
          Answer(id: 2, label: "To terminate the Future"),
          Answer(id: 3, label: "To ignore errors"),
          Answer(id: 4, label: "To pause the Future"),
        ],
      ),
      Question(
        id: 10,
        label: "What is the advantage of using asynchronous programming in Flutter?",
        correctAnswerId: 1,
        answers: [
          Answer(id: 1, label: "To avoid blocking the UI thread during long-running operations"),
          Answer(id: 2, label: "To make the code execution faster"),
          Answer(id: 3, label: "To simplify error handling"),
          Answer(id: 4, label: "To eliminate the need for callbacks"),
        ],
      ),
    ];
  }

