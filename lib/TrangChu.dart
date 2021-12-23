import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Ball.dart';
import 'GameOver.dart';
import 'MyBrick.dart';
import 'NutPlay.dart';
import 'Player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.003; // toc do bong theo truc X
  double ballYincrements = 0.003; // toc do cua bong theo truc Y
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // player variales
  double playerX = -0.2; // can chinh thanh di chuyen trong man hinh game
  double playerWidth = 0.4; // do dai cua thanh di chuyen

  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.1;
  static double brickGap = 0.01;// khoang cach giua 2 thanh o tren
  static int numberBricksInRow = 3;
  static double wallGap = 0.5 * (2-numberBricksInRow*brickWidth - (numberBricksInRow-1)*brickGap);
  //bool brickBroken = false;

  List MyBricks = [
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2* (brickWidth + brickGap) , firstBrickY, false],

  ];

  // Game setting
  bool hasGameStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      updateDirection();
      moveBall();

      // check gameOver
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      checkForBrokenBricks();
    });
  }

  void checkForBrokenBricks() {
    for(int i =0; i< MyBricks.length; i++){
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          double leftSideDist =(MyBricks[i][0] - ballX).abs();
          double rightSideDist =(MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist =(MyBricks[i][1] - ballY).abs();
          double bottomSideDist =(MyBricks[i][1] + brickHeight - ballY).abs();

          String min = findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch(min){
            case 'left' :
              ballXDirection = direction.LEFT;
              break;

            case 'right' :
              ballXDirection = direction.RIGHT;
              break;

            case 'top' :
              ballYDirection = direction.UP;
              break;

            case 'bottom' :
              ballYDirection = direction.DOWN;
              break;
            default:
          }
        });
      }
    }
  }


  String findMin(double a,double b, double c,double d){
    List<double> myList =[
      a,
      b,
      c,
      d,
    ];

    double currentMin = a;
    for(int i=0; i<myList.length; i++){
      if(myList[i] < currentMin){
        currentMin = myList[i];
      }
    }

    if((currentMin-a).abs() < 0.01){
      return'left';
    } else if((currentMin-b).abs() < 0.01){
      return'right';
    }else if((currentMin-c).abs() < 0.01){
      return'top';
    }else if((currentMin-d).abs() < 0.01){
      return'bottom';
    }
    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveBall() {
    setState(() {
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXincrements;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXincrements;
      }

      if (ballYDirection == direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  // Thanh di chuyen sang ben trai

  void moveLeft() {
    setState(() {
      if (!(playerX - 0.2 <= -1.1)) {
        playerX -= 0.2;
      }
    });
  }
// thanh di chuyen sang ben phai
  void moveRight() {
    if (!(playerX + playerWidth >= 0.95)) {
      playerX += 0.2; // toc do di chuyen sang phai cua thanh button
    }
  }

  void resetGame(){
    setState(() {
      playerX = -0.2;
      ballX =0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      MyBricks = [
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2* (brickWidth + brickGap) , firstBrickY, false],

      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.cyanAccent[100],
          body: Center(
            child: Stack(
              children: [
                ConverScreen(hasGameStarted: hasGameStarted),

                GameOverScreen(isGameOver: isGameOver, function: resetGame,),
                //ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,

                ),

                // player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
                MyBrick(
                  brickX: MyBricks[0][0],
                  brickY: MyBricks[0][1],
                  brickBroken: MyBricks[0][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,

                ),
                MyBrick(
                  brickX: MyBricks[1][0],
                  brickY: MyBricks[1][1],
                  brickBroken: MyBricks[1][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,

                ),
                MyBrick(
                  brickX: MyBricks[2][0],
                  brickY: MyBricks[2][1],
                  brickBroken: MyBricks[2][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
