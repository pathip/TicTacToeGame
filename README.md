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
- class _TicTacToeGameState extends State<TicTacToeGame> {
  int gridSize = 3; //ขนาดเริ่มต้นของกระดาน
  late List<List<String>> board; // arugment ที่สำหรับปรับขนาดของกระดาน
  bool isXTurn = true; // arugment ที่บอกว่าถึงเทิร์นของผู้เล่นแล้วหรือไม่

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  } //ฟังก์ชั่นนี้จะเรียกใช้งานฟังก์ชั้น _initializeBoard()

  void _initializeBoard() {
    board = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    gameOver = false;
  } //เป็นฟังก์ชั้นปรับขนาด board ตามที่ผู้เล่นกรอกใน Textfield

  void _handleTap(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
      });
    }
  } //ฟังก์ชั่นนี้จะปรับขนาดหน้าเจอตามขนาดกระดานที่ผู้เล่นกำหนด

  void _resetGame(int newSize) {
    setState(() {
      gridSize = newSize;
      _initializeBoard();
      isXTurn = true;
    });
  }//ฟังก์ชั้นนี้จะเป็นการ Reset เกมให้เป็นค่าเริ่มต้นอีกครั้ง

  
