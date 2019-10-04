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

    // 점 정보 리스트 저장 후 화면은 갱신합니다.
    setState(() {
      Point p = new Point(posx, posy);
      g.addPoint(p);
      print("디버깅 : " + g.getPointListSize.toString());
    });
  }

  @override
  void paint(Canvas canvas, Size size){
    final p1 = Offset(50, 50);
    final p2 = Offset(250, 150);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  void onClickDraw() {
    for(Point i in g.ps){
      print("x 값 : " + i.x.toString());
      print("y 값 : " + i.y.toString());
    }

    //mPathPainter.paint();
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
              onTapDown: (TapDownDetails details) => onTapDown(context, details),
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
                    painter: mPathPainter,
                  ),

                  Center(
                    child: Text(
                      "점을 찍어보세요!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:20,
                      ),
                    ),
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
                onPressed: onClickDraw,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
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

class PathPainter extends CustomPainter {
  Geometric g;

  PathPainter(Geometric g) {
    this.g = g;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    print("paint 함수 호출");
    for(int i = 0; i < g.getPointListSize - 1; i++){
      Offset p1 = Offset(g.ps.elementAt(i).x, g.ps.elementAt(i).y);
      Offset p2 = Offset(g.ps.elementAt(i + 1).x, g.ps.elementAt(i + 1).y);
      canvas.drawLine(p1, p2, paint);
    }

    /*
    Path path = Path();
    // TODO: do operations here
    for(int i = 0; i < g.getPointListSize - 1; i++){
      path.lineTo(g.ps.elementAt(i).x, g.ps.elementAt(i).y);
      canvas.drawPath(path, paint);
    }
        path.close();
    */
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
