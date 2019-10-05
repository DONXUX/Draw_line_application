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
  /// 점을 추가합니다.
  void addPoint(Point p1){
    if(ps.length >= _queueMaxSize)
      ps.removeLast();
    ps.addFirst(p1);
    order.add(getPointListSize - 1);
    for(int i=0;i<getPointListSize;i++){
      print("order["+i.toString()+"] = " + order[i].toString());
    }
  }

  /// 점을 제거합니다.
  void delPoint(){
    ps.removeFirst();
  }

  void orderChange() {
    if(permutation(0, order.length)){
      for(int i = 0; i < order.length; i++){
        print(order[i]);
      }
    }
    else {
      for(int i=0;i<order.length;i++){
        order[i]=i;
      }
      print("permutation 마지막");
    }
  }

  bool permutation(int begin, int end){
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
        swap(i, k);
        reverse(j, end);
        return true;
      }
      if(i == begin){
        reverse(begin, end);
        return false;
      }
    }
  }

  void swap(int a, int b){
    int tmp = order[a];
    order[a] = order[b];
    order[b] = tmp;
  }

  void reverse(int begin, int end) {
    end--;
    while (begin < end)
      swap(begin++, end--);
  }

  bool isCross(){

  }
}