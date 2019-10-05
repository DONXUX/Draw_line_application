import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/controller/draw.dart';
import 'package:flutter_app/data/geometric.dart';

/// 메인화면을 담당하는 클래스입니다.
/// 점을 찍고 라인을 그리는 화면을 담당합니다.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw Line',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Draw Line'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Draw _controller = Draw();
  static Geometric g = new Geometric(5);
  PathPainter mPathPainter = new PathPainter(g);
  bool visibleGreet = true;
  PathPainter isPainterDisabled = null;
  bool isBtnDrawDisabled = true;
  bool isBtnNextDisabled = true;
  bool isTapDownDisabled = false;
  //bool lineVisible = false;

  /// 화면 터치 이벤트입니다.
  /// 터치된 좌표를 입력받고 해당 좌표에 점을 띄웁니다.
  void onTapDown(BuildContext context, TapDownDetails details) {
    double posx = 0;
    double posy = 0;
    print("${details.globalPosition}");
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx - 16.0;
    posy = localOffset.dy - 100.0;

    // 점 정보 리스트 저장 후 화면을 갱신합니다.
    setState(() {
      visibleGreet = false;
      Point p = new Point(posx, posy);
      g.addPoint(p);
      if(g.getPointListSize > 1)
        isBtnDrawDisabled = false;
      //print("디버깅 : " + g.getPointListSize.toString());
    });
  }

  // 그리기 버튼 이벤트입니다.
  // 그려진 선이 보여집니다.
  void onClickDraw() {
    isTapDownDisabled = true;
    g.isCross();
    if(g.cross){
      g.orderChange();
    }
    setState((){
      isBtnDrawDisabled = true;
      isBtnNextDisabled = false;
      isPainterDisabled = mPathPainter;
    });
  }

  // 다음 버튼 이벤트입니다.
  // 선을 그리는 순서를 교차점이 생기지 않을 때 까지 바꿉니다.
  void onClickNext() {
    setState((){
      g.orderChange();
    });
  }

  // 초기화 버튼 이벤트입니다.
  // 초기상태로 돌아갑니다.
  void onClickClear(){
    setState(() {
      g.init();
      isBtnDrawDisabled = true;
      isBtnNextDisabled = true;
      isPainterDisabled = null;
      isTapDownDisabled = false;
      visibleGreet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTapDown: (TapDownDetails details) => isTapDownDisabled ? null : onTapDown(context, details),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // 점이 그려지는 컨테이너
                  Container(
                    color: Colors.amberAccent,
                    child: Stack(
                        fit: StackFit.expand,
                        children: g.ps
                          .map(_mapPoint)
                          .toList(),

                    ),
                  ),
                  // 선이 그려지는 페인트 위젯
                  CustomPaint(
                    painter: isPainterDisabled,
                  ),

                  Visibility(
                    visible: visibleGreet,
                    child: Center(
                      child: Text(
                        "점을 찍어보세요!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child:IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                        iconSize: 48.0,
                        onPressed: onClickClear,
                      )
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: Colors.deepOrange,
                child:Text(
                  "Draw!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.amberAccent
                  ),
                ),
                onPressed: isBtnDrawDisabled ? null : onClickDraw,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isBtnNextDisabled ? null : onClickNext,
        tooltip: '다음',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  // 점을 표현하는 위젯입니다.
  Widget _mapPoint(final Point point) => Positioned(
    left: point.x,
    top: point.y,
    child: Icon(
        Icons.lens,
        color: Colors.red,
        size: 8.0
    ),
  );
}

// 선 그리기를 담당하는 클래스입니다.
class PathPainter extends CustomPainter {
  Geometric g;
  List<int> order;

  PathPainter(Geometric g) {
    this.g = g;
  }

  @override
  void paint(Canvas canvas, Size size) {
    order = g.order;
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    print("paint 함수 호출");
    for(int i = 0; i < g.getPointListSize - 1; i++){
      Offset p1 = Offset(g.ps.elementAt(order[i]).x, g.ps.elementAt(order[i]).y);
      Offset p2 = Offset(g.ps.elementAt(order[i + 1]).x, g.ps.elementAt(order[i + 1]).y);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
