import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// 점 정보를 담고 있는 클래스(x, y 좌표)
class Point {
  int _x;
  int _y;

  Point(int x, int y){
   this._x = x;
   this._y = y;
  }

  // getter
  @override
  int get getX => this._x;
  @override
  int get getY => this._y;
}

/// 선 정보를 담고 있는 클래스(점1, 점2)
class Line {
  Point _p1;
  Point _p2;
  Point _pv;

  Line(Point p1, Point p2){
    this._p1 = p1;
    this._p2 = p2;
    this._pv = new Point(p2.getX- p1.getX, p2.getY - p1.getY);
  }

  // getter
  @override
  Point get getP1 => this._p1;
  @override
  Point get getP2 => this._p2;
}