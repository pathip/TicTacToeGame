<h1 align="center"> TicTacToeGame </h1> <br>

## Introduction
Project นี้คือเกม XO ที่ถูกสร้างผ่าน Flutter โดย Project นี้เป็น Project นี้เป็นการเขียนเกมผ่าน Flutter ครั้งแรกของผมมีจุดผิดพลาดจุดใดรบกวนชี้แนะด้วยครับ

## Features

*  ผู้เล่นจะได้สู้กับ AI ที่ใช้ ****MiniMax**** algorithm โดยจะประเมินผลทุกกรณีที่มีความเป็นไปได้
*  สามารถปรับกระดานได้สูงสุดถึง 10x10
*  มีระบบฐานข้อมูลที่สามารถบันทึกข้อมูลประวัติการเล่นของผู้เล่นได้

## Getting Started

โปรเจ็ดนี้จะใช้รูปแบบการเขียนดังนี้
- กระดานจะสามารถปรับขนาดกระดานได้แบบ dynamic โดยจะปรับได้สูงสุดถึง 10 x 10 โดยรูปแบบ Code จะเป็นดังนี้
```dart
class _TicTacToeGameState extends State<TicTacToeGame> {
int gridSize = 3; //ขนาดเริ่มต้นของกระดาน
late List<List<String>> board; // arugment ที่สำหรับปรับขนาดของกระดาน
bool isXTurn = true; // arugment ที่บอกว่าถึงเทิร์นของผู้เล่นแล้วหรือไม่
```

ฟังก์ชั่นนี้จะเรียกใช้งานฟังก์ชั้น _initializeBoard()
```dart
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }
```

เป็นฟังก์ชั้นปรับขนาด board ตามที่ผู้เล่นกรอกใน Textfield
```dart
  void _initializeBoard() {
    board = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    gameOver = false;
  }
```

ฟังก์ชั่นนี้จะปรับขนาดหน้าเจอตามขนาดกระดานที่ผู้เล่นกำหนด
```dart
  void _handleTap(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
      });
    }
  }
```

ฟังก์ชั้นนี้จะเป็นการ Reset เกมให้เป็นค่าเริ่มต้นอีกครั้ง
```dart
  void _resetGame(int newSize) {
    setState(() {
      gridSize = newSize;
      _initializeBoard();
      isXTurn = true;
    });
  }
```

build จะเป็นสร้างกระดานสำหรับการเล่นเกม XO ขึ้นมา
```dart
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
                  onTap: () => playMove(row, col), //จะเรียกให้ ai ทำงานหลังผู้เล่นเดินเสร็จ
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
```

- ระบบ AI และ ตรวจสอบผู้ชนะ , แพ้ ,เสมอ

script tictactoe.drat

ฟังก์นี้จะ check ว่าผู้เล่นเดินหรือยัง? และถ้าเดินแล้วฟังก์นี้จะไปเรียกฟังก์ชั่น aiMove() ใน script โดยส่ง arugment board ไปยังฟังก์ชั่น ai_bot.dart
```dart
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
```

ฟังก์ชั่นนี้เป็นการแสดงผลว่าผู้เล่นหรือ AI เป็นฝ่ายชนะ หรือ เสมอ โดยเช็คจากแนวตั้ง , แนวนอน หรือ แนวทะแยง และ ฟังก์ชั่น Reset เกมเป็นค่า boolen GameOver = true
 
 ```dart
 String? _checkWinner() {
    // ตรวจสอบแถวและคอลัมน์
    for (int i = 0; i < gridSize; i++) {
      if (_checkLine(board[i])) return board[i][0]; // เช็คแถว
      if (_checkLine(List.generate(gridSize, (j) => board[j][i]))) return board[0][i]; // เช็คคอลัมน์
    }

    // ตรวจสอบแนวทแยง
    if (_checkLine(List.generate(gridSize, (i) => board[i][i]))) return board[0][0];
    if (_checkLine(List.generate(gridSize, (i) => board[i][gridSize - i - 1]))) return board[0][gridSize - 1];

    return null;
  }

  bool _checkLine(List<String> line) {
    return line.every((cell) => cell.isNotEmpty && cell == line[0]);
  }

  bool _isDraw() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showResultDialog(String result) {
    setState(() {
      gameOver = true;
    });

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
```

script ai_bot.drat

```dart
//ฟังก์ชันเช็กว่ามีใครชนะหรือไม่
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
```

- ระบบฐานข้อมูลที่สามารถบันทึกข้อมูลประวัติการเล่นของผู้เล่นได้

ระบบฐานข้อมูลนี้จะใช้ SQLite (sqflite) เพื่อบันทึกข้อมูลที่เล่นไป
โดยโครงสร้างของฐานข้อมุลดังนี้
  
  id: ไอดีของเกม
  gridSize: ขนาดของกระดาน
  history: ลำดับการเล่น (เก็บเป็น JSON)
  winner: ผู้ชนะ (X, O หรือ Draw)
  timestamp: เวลาที่เล่น

โดยจะใช้ script database_helper.dart สำหรับเก็บข้อมูลเกมโดยเฉพาะ

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("game_history.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gridSize INTEGER,
        history TEXT,
        winner TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertGame(int gridSize, List<List<String>> moves, String winner) async {
    final db = await database;
    return await db.insert('history', {
      'gridSize': gridSize,
      'history': jsonEncode(moves),
      'winner': winner,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
```

คราวนี้จะเชื่อมระบบ History เข้ากับ script tictacgame.dart
```dart
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
```

ใน script tictacgame.dart จะเพิ่ม class HistoryPage เพื่อสร้างหน้าแสดงข้อมุล replay ที่บันทึกไว้ด้วย
```dart
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
  //โหลดประวัติการเล่นทั้งหมด
  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getHistory();
    setState(() {
      historyData = data;
    });
  }
  //ล้างประวัติการเล่นทั้งหมด
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
  //แสดง Replay ที่เลือก
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
```

## how to setup and install

ไปที่ Tic Tac Toe - Test Project\tic_tac_toe_game\build\app\outputs\flutter-apk แล้ว install ผ่าน app-release.apk ได้เลย (แนะนำลงผ่าน emulator android นะครับ)
