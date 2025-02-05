import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/tictacgame.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToeGame(),
    );
  }
}