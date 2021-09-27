import 'package:flutter/material.dart';
import 'package:memo_0731/database/db.dart';
import 'package:memo_0731/database/memo.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class WritePage extends StatelessWidget {

  final Function updateScreen_home;

  WritePage({this.updateScreen_home});

  String title = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevent keyboard overflow
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){saveDB(context);},
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String title) { this.title = title; },
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              obscureText: false,
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                  hintText: '메모 제목을 적어주세요',
                labelText: '제목'
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(color: Colors.red),),
            TextField(
              onChanged: (String content) { this.text = content; },
              keyboardType: TextInputType.multiline,
              //maxLines: null, <- this not good with keyboard
              maxLines: 8,
              obscureText: false,
              decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '내용 입력',
                  labelText: '내용'
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> saveDB(BuildContext context) async {

    DBHelper sd = DBHelper();

    var fido = Memo(
      id: StrTosha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );

    await sd.insertMemo(fido);
    print(await sd.memos());
    updateScreen_home();
    Navigator.pop(context, '수정완료');
  }

  String StrTosha512(String text) {
    var bytes = utf8.encode(text);

    var digest = sha512.convert(bytes);

    return digest.toString();
  }

}
