import 'dart:io';

void main() async {
  final server = await HttpServer.bind('127.0.0.1', 8080);
  final clients = <WebSocket>{};

  print('Chat server is running on ${server.address}:${server.port}');

  await for (var request in server) {
    try {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final webSocket = await WebSocketTransformer.upgrade(request);
        print('New client connected');
        clients.add(webSocket);

        _startListening(webSocket, clients);
      }
    } catch (e) {
      print('Error during WebSocket upgrade: $e');
    }
  }
}

void _startListening(WebSocket webSocket, Set<WebSocket> clients) {
  webSocket.listen(
    (message) {
      print('Received: $message');
      _broadcastMessage(message, clients, webSocket);
    },
    onDone: () {
      print('Client disconnected');
      clients.remove(webSocket);
    },
  );
}

void _broadcastMessage(String message, Set<WebSocket> clients, WebSocket sender) {
  for (var client in clients) {
    if (client != sender) {
      client.add(message);
    }
  }
}
