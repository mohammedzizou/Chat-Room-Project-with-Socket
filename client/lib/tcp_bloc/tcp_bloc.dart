import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import '../models/message.dart';

part 'tcp_event.dart';
part 'tcp_state.dart';

class TcpBloc extends Bloc<TcpEvent, TcpState> {
  Socket? _socket;
  StreamSubscription? _socketStreamSub;
  ConnectionTask<Socket>? _socketConnectionTask;

  TcpBloc() : super(TcpState.initial());

  @override
  Stream<TcpState> mapEventToState(
    TcpEvent event,
  ) async* {
    if (event is Connect) {
      yield* _mapConnectToState(event);
    } else if (event is Disconnect) {
      yield* _mapDisconnectToState();
    } else if (event is ErrorOccured) {
      yield* _mapErrorToState();
    } else if (event is MessageReceived) {
      yield state.copyWithNewMessage(message: event.message);
    } else if (event is SendMessage) {
      yield* _mapSendMessageToState(event);
    } else if (event is SendImage) {
      yield* _mapSendImageToState(event);
    }
  }

  Stream<TcpState> _mapConnectToState(Connect event) async* {
    yield state.copywith(connectionState: SocketConnectionState.Connecting);
    try {
      print('Connecting to ${event.host}:${event.port}...');
      _socket = await Socket.connect(event.host, event.port);
      print('Connected to ${event.host}:${event.port}');
      _socket!.listen(
        (Uint8List data) {
          // Check if the received data is an image
          if (data.isNotEmpty && data[0] == 1) {
            // Image data
            print('Received image from server.');

            // Dispatch an event to handle the received image
            add(MessageReceived(
              message: Message(
                  message: "image",
                  timestamp: DateTime.now(),
                  sender: Sender.Server,
                  isImage: true,
                  imageData: data.sublist(1)),
            ));
          } else {
            print("========================================1");
            // Text message
            final msg = utf8.decode(data).trim(); // Decode the received data
            print('Received message from server: $msg');
            print("========================================2");
            // Dispatch an event to handle the received message
            add(MessageReceived(
              message: Message(
                message: msg,
                timestamp: DateTime.now(),
                sender: Sender.Server,
              ),
            ));
          }
        },
        onError: (error) {
          print('Error occurred: $error');
          add(ErrorOccured());
        },
        onDone: () {
          print('Server left.');
          _socket!.destroy();
        },
      );

      yield state.copywith(connectionState: SocketConnectionState.Connected);
    } catch (err) {
      print('Connection failed: $err');
      yield state.copywith(connectionState: SocketConnectionState.Failed);
    }
  }

  Stream<TcpState> _mapDisconnectToState() async* {
    try {
      yield state.copywith(
          connectionState: SocketConnectionState.Disconnecting);
      _socketConnectionTask?.cancel();
      await _socketStreamSub?.cancel();
      await _socket?.close();
    } catch (ex) {
      print(ex);
    }
    yield state
        .copywith(connectionState: SocketConnectionState.None, messages: []);
  }

  Stream<TcpState> _mapErrorToState() async* {
    yield state.copywith(connectionState: SocketConnectionState.Failed);
    await _socketStreamSub?.cancel();
    await _socket?.close();
  }

  Stream<TcpState> _mapSendMessageToState(SendMessage event) async* {
    if (_socket != null) {
      yield state.copyWithNewMessage(
          message: Message(
        message: event.message,
        timestamp: DateTime.now(),
        sender: Sender.Client,
      ));
      _socket!.writeln(event.message);
    }
  }

  // Stream<TcpState> _mapSendImageToState(SendImage event) async* {
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       final imageFile = File(pickedFile.path);
  //       final imageBytes = await imageFile.readAsBytes();

  //       if (_socket != null) {
  //         // Send image data prefixed with identifier '1'
  //         _socket!.add([1]);
  //         _socket!.add(imageBytes);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error sending image: $e');
  //   }
  // }
  Stream<TcpState> _mapSendImageToState(SendImage event) async* {
    if (_socket != null) {
      // Send image data to the server
      _socket!.add([1]); // Prefix indicating image data
      _socket!.add(event.imageData);

      // Optionally, you can also update the UI to display the sent image
      yield state.copyWithNewMessage(
        message: Message(
          message: '[Image]',
          timestamp: DateTime.now(),
          sender: Sender.Client,
          isImage: true, // Set flag to indicate it's an image
          imageData: event.imageData, // Store image data in the message
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _socketStreamSub?.cancel();
    _socket?.close();
    return super.close();
  }
}
