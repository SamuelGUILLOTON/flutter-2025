import 'dart:io';
import 'dart:convert'; // Import the 'dart:convert' library for utf8

void main() async {
  final socket = await WebSocket.connect('ws://localhost:8080');

  socket.listen(
    (message) {
      print('Received: $message');
    },
    onDone: () {
      print('Server disconnected');
      exit(0);
    },
  );

  await _readUserInput(socket);
}

Future<void> _readUserInput(WebSocket socket) async {
  final stdinStream = stdin.transform(utf8.decoder).transform(LineSplitter());

  await for (var line in stdinStream) {
    socket.add(line);
  }
}
