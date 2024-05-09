import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/main_page.dart';
import 'tcp_bloc/tcp_bloc.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TcpBloc>(create: (context) => TcpBloc()),
      ],
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}