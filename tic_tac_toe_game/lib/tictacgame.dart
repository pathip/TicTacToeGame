import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'ai_bot.dart'; // นำเข้า AI Bot
import 'dart:convert';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  int gridSize = 3;
  late List<List<String>> board;
  bool isXTurn = true;
  bool gameOver = false;

  //Ai Bot
  void playMove(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = 'X'; // ผู้เล่นเดิน
        if (!checkWin(board) && !isBoardFull(board)) {
          aiMove(board); // ให้ AI ตอบโต้
        }
      });
    }

    String? winner = _checkWinner();
      if (winner != null) {
        _showResultDialog("$winner ชนะ!");
      } else if (_isDraw()) {
        _showResultDialog("เสมอ!");
      }
  }
  //Ai Bot

  //Check Winner,Loss,Draw
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    board = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    gameOver = false;
  }

  String? _checkWinner() {
    // ตรวจสอบแถวและคอลัมน์
    for (int i = 0; i < gridSize; i++) {
      if (_checkLine(board[i])) return board[i][0]; // เช็คแถว
      if (_checkLine(List.generate(gridSize, (j) => board[j][i]))) {
        return board[0][i]; // เช็คคอลัมน์
      }
    }

    // ตรวจสอบแนวทแยง
    if (_checkLine(List.generate(gridSize, (i) => board[i][i]))) {
      return board[0][0];
    }
    if (_checkLine(
        List.generate(gridSize, (i) => board[i][gridSize - i - 1]))) {
      return board[0][gridSize - 1];
    }

    return null;
  }

  bool _checkLine(List<String> line) {
    return line.every((cell) => cell.isNotEmpty && cell == line[0]);
  }

  bool _isDraw() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _saveGameHistory() async {
    await DatabaseHelper.instance.insertGame(gridSize, board, _getWinnerText());
  }

  String _getWinnerText() {
    String? winner = _checkWinner();
    return winner ?? (_isDraw() ? "Draw" : "");
  }

  void _showResultDialog(String result) {
    setState(() {
      gameOver = true;
    });

    // บันทึกลงฐานข้อมูล
    _saveGameHistory();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(gridSize);
              },
              child: Text("เล่นใหม่"),
            ),
          ],
        );
      },
    );
  }

  void _resetGame(int newSize) {
    setState(() {
      gridSize = newSize;
      _initializeBoard();
      isXTurn = true;
    });
  }
  //Check Winner,Loss,Draw

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tic-Tac-Toe (Dynamic)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Grid Size: "),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "$gridSize"),
                    onSubmitted: (value) {
                      int? newSize = int.tryParse(value);
                      if (newSize != null && newSize > 2 && newSize <= 10) {
                        _resetGame(newSize);
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () => _resetGame(gridSize),
                    child: Text("Reset")),
                IconButton(
                  icon: Icon(Icons.history),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: gridSize * gridSize,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ gridSize;
                int col = index % gridSize;
                return GestureDetector(
                  //onTap: () => _handleTap(row, col),
                  onTap: () => playMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    alignment: Alignment.center,
                    child:
                        Text(board[row][col], style: TextStyle(fontSize: 32)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// History
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getHistory();
    setState(() {
      historyData = data;
    });
  }

  void _clearHistory() async {
    await DatabaseHelper.instance.clearHistory();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Game History"), actions: [
        IconButton(icon: Icon(Icons.delete), onPressed: _clearHistory),
      ]),
      body: ListView.builder(
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final game = historyData[index];
          final moves = jsonDecode(game['history']) as List<List<String>>;
          return ListTile(
            title: Text("Grid ${game['gridSize']}x${game['gridSize']}"),
            subtitle: Text("Winner: ${game['winner']}"),
            trailing: Text(game['timestamp'].substring(0, 16)),
            onTap: () => _showReplay(moves),
          );
        },
      ),
    );
  }

  void _showReplay(List<List<String>> moves) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Replay"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: moves.map((row) => Text(row.join(" "))).toList(),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Close"))
          ],
        );
      },
    );
  }
  //History
}
