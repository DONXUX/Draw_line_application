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
  Point get getP1 => this._p1;
  Point get getP2 => this._p2;
}

/// 점, 선 리스트큐를 담고있는 클래스입니다.
class Geometric {
  ListQueue<Point> ps;
  ListQueue<Line> ls;
  List<int> order;
  int _queueMaxSize;
  bool cross = false;
  List _lineOrder;
  List<bool> _visitedLineOrder;

  Geometric(int size) {
    ps = new ListQueue();
    ls = new ListQueue();
    order = new List();
    _queueMaxSize = size;
  }

  int get getPointListSize => this.ps.length;

  void init(){
    ps.clear();
    order.clear();
  }
  /// 점을 추가합니다. 최대 5개까지 저장하며 점이 5개 초과 시 Queue 자료구조를 이용해 마지막 원소는 pop을 하여 5개로 유지합니다.
  void addPoint(Point p1){
    ps.addFirst(p1);
    if(ps.length > _queueMaxSize) {
      ps.removeLast();
    }
    else{
      order.add(getPointListSize - 1);
    }
  }

  // 선을 그리는 순서를 변경합니다.
  void orderChange() {
    if(!_permutation(0, order.length)){
      for(int i = 0; i < order.length; i++){
        order[i] = i;
      }
      print("permutation 마지막");
    }

    // 점이 3개 초과 시 교차 검사를 진행합니다.
    if(getPointListSize > 3){
      isCross();
      print("cross : $cross");
      if(cross) {
        cross = false;
        orderChange();
      }
    }
  }

  // 다음 순열로 수정하는 메소드입니다.
  bool _permutation(int begin, int end){
    if(begin == end)
      return false;
    if(begin + 1 == end)
      return false;

    int i = end - 1;
    while(true){
      int j = i--;
      if(order[i] < order[j]){
        int k = end;
        while(!(order[i] < order[--k])) {
          // pass
        }
        _swap(i, k);
        _reverse(j, end);
        return true;
      }
      if(i == begin){
        _reverse(begin, end);
        return false;
      }
    }
  }

  void _swap(int a, int b){
    int tmp = order[a];
    order[a] = order[b];
    order[b] = tmp;
  }

  void _reverse(int begin, int end) {
    end--;
    while (begin < end)
      _swap(begin++, end--);
  }

  void isCross(){
    // 만들어진 선을 저장합니다.
    _lineOrder = new List();
    _visitedLineOrder = new List();
    for(int i = 0; i < getPointListSize - 1; i++){
      Point p1 = ps.elementAt(order[i]);
      Point p2 = ps.elementAt(order[i + 1]);
      ls.add(new Line(p1, p2));
      _visitedLineOrder.add(false);
    }
    print("Linesize : " + ls.length.toString());

    _selectTwoLine(0);

    // 선 리스트를 초기화합니다.
    ls.clear();
    _visitedLineOrder.clear();
  }

  // 백트래킹을 이용한 선 교차 확인 순서를 정합니다.
  void _selectTwoLine(int cnt) {
    if(cnt == 2){
      if(cross) return;
      print("lineOrder[0] : " + _lineOrder.elementAt(0).toString());
      print("lineOrder[1] : " + _lineOrder.elementAt(1).toString());

      Line l1 = ls.elementAt(_lineOrder.elementAt(0));
      Line l2 = ls.elementAt(_lineOrder.elementAt(1));
      Point p1 = new Point(l1.getP1.x, l1.getP1.y);
      Point p2 = new Point(l1.getP2.x, l1.getP2.y);
      Point p3 = new Point(l2.getP1.x, l2.getP1.y);
      Point p4 = new Point(l2.getP2.x, l2.getP2.y);
      int ccwRet1 = _ccw(p1, p2, p3) * _ccw(p1, p2, p4);
      int ccwRet2 = _ccw(p3, p4, p1) * _ccw(p3, p4, p2);
      cross = (ccwRet1 < 0) && (ccwRet2 < 0);
      return;
    }

    for(int i = 0; i < ls.length; i++){
      if(_visitedLineOrder.elementAt(i)) continue;
      for(int j = 0; j <= i; j++){
        _visitedLineOrder[j] = true;
      }
      _lineOrder.add(i);
      _selectTwoLine(cnt + 1);
      for(int j = 0; j <= i; j++){
        _visitedLineOrder[j] = false;
      }
      _lineOrder.removeLast();
    }
  }

  int _ccw(Point p1, Point p2, Point p3){
    double op = (p1.x * p2.y) + (p2.x * p3.y) + (p3.x * p1.y);
    op -= ((p1.y * p2.x) + (p2.y * p3.x) + (p3.y * p1.x));
    print("op $op");
    if(op > 0) return 1;
    else if(op == 0) return 0;
    else return -1;
  }
}