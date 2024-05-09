import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

const port = 3000;
List<Socket> clients = [];

Future<void> startServer() async {
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind("0.0.0.0", port);
  print('TCP server started at ${server.address}:${server.port}.');

  try {
    server.listen((Socket socket) {
      print(
          'New TCP client ${socket.address.address}:${socket.port} connected.');
      clients.add(socket);
      // socket.writeln("Welcome to the chat server!");

      socket.listen((Uint8List data) {
        if (data.isNotEmpty) {
          // Check if the data is an image
          if (data[0] == 1) {
            // Image data
            print(
                'Received image from client ${socket.address.address}:${socket.port}.');

            // Broadcast the image to all clients
            for (var client in clients) {
              if (client != socket) {
                client.add(data);
              }
            }
          } else {
            // Text message
            final msg = utf8.decode(data).trim(); // Decode the received data
            print(
                'Received message from client ${socket.address.address}:${socket.port}: $msg');

            // Broadcast the message to all clients
            for (var client in clients) {
              if (client != socket) {
                client.writeln(msg);
              }
            }
          }
        }
      }, onError: (error) {
        print(
            'Error for client ${socket.address.address}:${socket.port}: $error');
        clients.remove(socket);
      }, onDone: () {
        print(
            'Connection to client ${socket.address.address}:${socket.port} done.');
        clients.remove(socket);
      });
    });
  } on SocketException catch (ex) {
    print(ex.message);
  }
}

void main() {
  startServer();
}
