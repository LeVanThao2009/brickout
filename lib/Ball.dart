import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final ballX;
  final ballY;
  final bool isGameOver;
  final bool hasGameStarted;

  MyBall(
      {this.ballX,
      this.ballY,
      required this.hasGameStarted,
      required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            child: Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              decoration: BoxDecoration(
                color: isGameOver ? Colors.deepPurple[300] : Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              height: 10,
              width: 10,
            ),
          ))
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              endRadius: 60.0,
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    height: 15,
                    width: 15,
                  ),
                  radius: 7.0,
                ),
              ),
            ),
          );
  }
}
