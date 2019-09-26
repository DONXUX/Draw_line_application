import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw Line',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  void onClickNext(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                Text(
                  "점을 찍으세요",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:20,
                  ),
                ),
                Container(
                  //TODO: 그리기
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClickNext,
        tooltip: '다음',
        child: Icon(Icons.arrow_forward_ios),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
