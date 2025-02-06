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
```js
class _TicTacToeGameState extends State<TicTacToeGame> {
int gridSize = 3; //ขนาดเริ่มต้นของกระดาน
late List<List<String>> board; // arugment ที่สำหรับปรับขนาดของกระดาน
bool isXTurn = true; // arugment ที่บอกว่าถึงเทิร์นของผู้เล่นแล้วหรือไม่
```

ฟังก์ชั่นนี้จะเรียกใช้งานฟังก์ชั้น _initializeBoard()
```js
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }
```

เป็นฟังก์ชั้นปรับขนาด board ตามที่ผู้เล่นกรอกใน Textfield
```js
  void _initializeBoard() {
    board = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    gameOver = false;
  }
```

ฟังก์ชั่นนี้จะปรับขนาดหน้าเจอตามขนาดกระดานที่ผู้เล่นกำหนด
```js
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
```js
  void _resetGame(int newSize) {
    setState(() {
      gridSize = newSize;
      _initializeBoard();
      isXTurn = true;
    });
  }
```

build จะเป็นสร้างกระดานสำหรับการเล่นเกม XO ขึ้นมา
```js
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
```js
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

  
