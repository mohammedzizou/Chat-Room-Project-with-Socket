part of 'tcp_bloc.dart';

@immutable
abstract class TcpEvent {}

/// Represents a request for a connection to a server.
class Connect extends TcpEvent {
  /// The host of the server to connect to.
  final dynamic host;

  /// The port of the server to connect to.
  final int port;

  Connect({required this.host, required this.port}) : assert(host != null);

  @override
  String toString() => '''Connect {
    host: $host,
    port: $port
  }''';
}

/// Represents a request to disconnect from the server or abort the current connection request.
class Disconnect extends TcpEvent {
  @override
  String toString() => 'Disconnect { }';
}

/// Represents a socket error.
class ErrorOccured extends TcpEvent {
  @override
  String toString() => '''ErrorOccured { }''';
}

/// Represents the event of an incoming message from the TCP server.
class MessageReceived extends TcpEvent {
  final Message message;

  MessageReceived({required this.message});

  @override
  String toString() => '''MessageReceived {
    message: $message,
  }''';
}

/// Represents a request to send a message to the TCP server.
class SendMessage extends TcpEvent {
  /// The message to be sent to the TCP server.
  final String message;

  SendMessage({required this.message});

  @override
  String toString() => 'SendMessage { }';
}

/// Represents a request to send an image to the TCP server.
// class SendImage extends TcpEvent {
//   @override
//   String toString() => 'SendImage { }';
// }
class SendImage extends TcpEvent {
  final Uint8List imageData;

  SendImage({required this.imageData});

  @override
  String toString() => 'SendImage { }';
}
