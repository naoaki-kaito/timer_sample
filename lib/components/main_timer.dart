import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timer_sample/components/main_timer.dart';


class MainTimer extends StatefulWidget {
  @override
  _MainTimerState createState() => _MainTimerState();
}

class _MainTimerState extends State<MainTimer> {

  static bool _isCounting = false;
  static int _defaultSeconds = 5;
  static int _seconds = _defaultSeconds;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //現在のカウントを表示
                    Text(_seconds.toString(),
                      style: TextStyle(fontSize: 100),
                    ),

                    if(!_isCounting)
                    //編集ボタン
                      RaisedButton(
                        child: Text('EDIT'),
                        onPressed: () {
                          _showEditDialog();
                        },
                      )
                  ],
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // START, STOPボタン
                RaisedButton(
                  child: Text(_isCounting ? 'STOP' : 'START'),
                  onPressed: () {
                    _handleTimer();
                  },
                ),
                Container(width: 30),
                if (!_isCounting)
                // RESETボタン
                  RaisedButton(
                    child: Text('RESET'),
                    onPressed: () {
                      setState(() {
                        _reset();
                      });
                    },
                  )
              ],
            )
          ]
      ),
    );

  }

  Timer _timer;

  // START, STOP の処理
  void _handleTimer() {
    setState(() {
      _isCounting = !_isCounting;
    });

    if (_isCounting) {
      //1秒ごとにカウントダウンする
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _seconds--;
        });

        if (_seconds <= 0) {
          //完了ダイアログを表示
          _showFinishedDialog();

          //カウントを止める
          _timer.cancel();
        }
      });
      //STOPの場合
    } else {
      //カウントを止める
      _timer.cancel();
    }
  }

  // リセット処理
  void _reset() {
    _seconds = _defaultSeconds;
  }

  //編集ダイアログを開く
  void _showEditDialog() {

    int newSeconds = 0;

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 400,
              child: Column(
                children: <Widget>[
                  //時間設定のドラム
                  CupertinoTimerPicker(
                    initialTimerDuration: Duration(seconds: _defaultSeconds),
                    mode: CupertinoTimerPickerMode.ms,
                    onTimerDurationChanged: (Duration duration) {
                      newSeconds = duration.inSeconds;
                    },
                  ),

                  //決定ボタン
                  RaisedButton(
                    child: Text('SAVE'),
                    onPressed: () {
                      setState(() {
                        _defaultSeconds = newSeconds;
                        _reset();
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  //完了ダイアログを表示
  void _showFinishedDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('タイマー終了'),
            content: Text('完了しました'),
            actions: <Widget>[
              RaisedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

}