import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: const [
              Text('Flutter TCP Demo'),
              Text('created by Azizou Mohammed'),
              Text('created with Flutter')
            ],
          ),
        ),
      ),
    );
  }
}
