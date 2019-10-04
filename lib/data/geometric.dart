import 'dart:collection';

import 'dart:math';

/// 선 정보를 담고 있는 클래스입니다.
class Line {
  Point _p1;
  Point _p2;
  Point _pv;

  Line(Point p1, Point p2){
    this._p1 = p1;
    this._p2 = p2;
    this._pv = new Point(p2.x - p1.x, p2.y - p1.y);
  }

  // getter
  @override
  Point get getP1 => this._p1;
  @override
  Point get getP2 => this._p2;
}

/// 점, 선 리스트큐를 담고있는 클래스입니다.
class Geometric {
  ListQueue<Point> ps;
  ListQueue<Line> ls;
  int _queueMaxSize;

  Geometric(int size) {
    ps = new ListQueue();
    ls = new ListQueue();
    _queueMaxSize = size;
  }

  @override
  int get getPointListSize => this.ps.length;

  /// 점을 추가합니다.
  void addPoint(Point p1){
    if(ps.length >= _queueMaxSize)
      ps.removeLast();
    ps.addFirst(p1);
  }

  /// 점을 제거합니다.
  void delPoint(){
    ps.removeFirst();
  }
}