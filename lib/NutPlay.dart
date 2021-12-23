import 'package:flutter/material.dart';

class ConverScreen extends StatelessWidget {
  final bool hasGameStarted ;
  ConverScreen({required this.hasGameStarted});

  Widget build(BuildContext context) {
    return hasGameStarted ? Container(): Container(
      alignment: Alignment(0, -0.1),
      child: Text('Tap To Play',style: TextStyle(color: Colors.amberAccent, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
