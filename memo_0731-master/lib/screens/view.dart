import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_0731/database/db.dart';
import 'package:memo_0731/database/memo.dart';

import 'edit.dart';

class ViewPage extends StatefulWidget {
  final String id;
  final Function updateScreen_home;

  ViewPage(this.id, {this.updateScreen_home});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    DBHelper sd = DBHelper(); // Future로 넘어온것을 받기 위해 다른 작업이 필요

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {showAlertDialog(context);},
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EditPage(
                        updateScreen_home: widget.updateScreen_home,
                        updateScreen_view: updateScreen_view,
                        id: widget.id)));
          },
        ),
      ]),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
        child: LoadBuilder(),
      ),
    );
  }

  Future<Memo> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  LoadBuilder() {
    return FutureBuilder<Memo>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<Memo> projectSnap) {
        if (projectSnap.data == null) {
          return Container(
              child: Text(
            "데이터를 불러올 수 없습니다.",
          ));
        } else {
          Memo memo = projectSnap.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                child: SingleChildScrollView(
                  child: Text(memo.title,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
                ),
              ),

              Text(
                "메모를 만든시간: " + memo.createTime.split('.')[0],
                style: TextStyle(fontSize: 11),
                textAlign: TextAlign.end,
              ),
              Text(
                "메모 수정 시간: " + memo.editTime,
                style: TextStyle(fontSize: 11),
                textAlign: TextAlign.end,
              ),
              Padding(padding: EdgeInsets.all(10)),
              Expanded(child: SingleChildScrollView(child: Text(memo.text)))
              // 내용이 길어질 수 있으므로
            ],
          );
        }
      },
    );
  }

  void deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
    widget.updateScreen_home();
  }

  void updateScreen_view() {
    setState(() {});
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고'),
          content: Text("정말 삭제하시겠습니까?\n 삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                deleteMemo(widget.id);
                Navigator.pop(context, "삭제");
                widget.updateScreen_home();
                Navigator.pop(context, "삭제2");
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }
}
