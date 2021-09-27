import 'package:flutter/material.dart';
import 'package:memo_0731/database/db.dart';
import 'package:memo_0731/database/memo.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class EditPage extends StatelessWidget {
  final String id;
  final Function updateScreen_home;
  final Function updateScreen_view;

  EditPage({this.updateScreen_home, this.updateScreen_view, this.id});

  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // prevent keyboard overflow
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              updateDB(context);
            },
          )
        ]),
        body:
            Padding(padding: const EdgeInsets.all(20.0), child: loadBuilder()));
  }

  Future<void> updateDB(BuildContext context) async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: this.id,
      title: this.title,
      text: this.text,
      createTime: this.createTime,
      editTime: DateTime.now().toString(),
    );

    await sd.updateMemo(fido);
    print(await sd.memos());
    updateScreen_home();
    updateScreen_view();
    Navigator.pop(context, '수정완료');
  }

  loadBuilder() {
    return FutureBuilder<Memo>(
        future: loadMemo(id),
        builder: (BuildContext context, AsyncSnapshot<Memo> snapshot) {
          if (snapshot.data == null || snapshot.data == []) {
            return Container(child: Text("데이터를 불러올 수 없습니다."));
          } else {
            Memo memo = snapshot.data;

            var tc_Title = TextEditingController();
            var tc_text = TextEditingController();

            title = memo.title;
            text = memo.text;
            createTime = memo.createTime;

            tc_Title.text = title;
            tc_text.text = text;


            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: tc_Title,
                  maxLines: 2,
                  onChanged: (String title) {
                    this.title = title;
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                Text(createTime, style: TextStyle(fontSize: 11)),
                Padding(padding: EdgeInsets.all(20)),
                TextField(
                  controller: tc_text,
                  maxLines: 8,
                  onChanged: (String text) {
                    this.text = text;
                  },
                ),
              ],
            );
          }
        });
  }

  Future<Memo> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }
}
