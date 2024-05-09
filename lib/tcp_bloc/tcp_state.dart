part of 'tcp_bloc.dart';

enum SocketConnectionState {
  Connecting,
  Disconnecting,
  Connected,
  Failed,
  None
}

@immutable
class TcpState {
  final SocketConnectionState connectionState;
  final List<Message> messages;

  const TcpState({
    required this.connectionState,
    required this.messages,
  });

  factory TcpState.initial() {
    return const TcpState(
        connectionState: SocketConnectionState.None, messages: <Message>[]);
  }

  TcpState copywith({
    SocketConnectionState? connectionState,
    List<Message>? messages,
  }) {
    return TcpState(
      connectionState: connectionState ?? this.connectionState,
      messages: messages ?? this.messages,
    );
  }

  TcpState copyWithNewMessage({required Message message}) {
    return TcpState(
      connectionState: connectionState,
      messages: List.from(messages)..add(message),
    );
  }
}
