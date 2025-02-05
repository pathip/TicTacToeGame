import 'dart:math';

// ฟังก์ชันเช็กว่ามีใครชนะหรือไม่
bool checkWin(List<List<String>> board) {
  int size = board.length;

  // เช็กแถวและคอลัมน์
  for (int i = 0; i < size; i++) {
    if (board[i].every((cell) => cell == 'O') || // เช็กแถว
        board.every((row) => row[i] == 'O')) {   // เช็กคอลัมน์
      return true;
    }
  }

  // เช็กแนวทแยง
  if (List.generate(size, (i) => board[i][i]).every((cell) => cell == 'O') ||
      List.generate(size, (i) => board[i][size - 1 - i]).every((cell) => cell == 'O')) {
    return true;
  }

  return false;
}

// ฟังก์ชันเช็กว่าเต็มกระดานหรือยัง
bool isBoardFull(List<List<String>> board) {
  for (var row in board) {
    if (row.contains('')) return false;
  }
  return true;
}

// Minimax Algorithm สำหรับ AI
int minimax(List<List<String>> board, bool isMaximizing) {
  if (checkWin(board)) return isMaximizing ? -1 : 1;
  if (isBoardFull(board)) return 0;

  int bestScore = isMaximizing ? -1000 : 1000;
  String player = isMaximizing ? 'O' : 'X';

  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      if (board[i][j] == '') {
        board[i][j] = player;
        int score = minimax(board, !isMaximizing);
        board[i][j] = '';
        bestScore = isMaximizing ? max(score, bestScore) : min(score, bestScore);
      }
    }
  }
  return bestScore;
}

// ฟังก์ชันให้ AI เลือกเดิน
void aiMove(List<List<String>> board) {
  int bestScore = -1000;
  int bestRow = -1, bestCol = -1;

  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      if (board[i][j] == '') {
        board[i][j] = 'O';
        int score = minimax(board, false);
        board[i][j] = '';

        if (score > bestScore) {
          bestScore = score;
          bestRow = i;
          bestCol = j;
        }
      }
    }
  }

  if (bestRow != -1 && bestCol != -1) {
    board[bestRow][bestCol] = 'O';
  }
}
