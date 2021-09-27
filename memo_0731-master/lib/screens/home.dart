import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_0731/database/memo.dart';
import 'package:memo_0731/database/db.dart';
import 'package:memo_0731/screens/view.dart';
import 'package:memo_0731/screens/write.dart';

import 'edit.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String delete_id = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.autorenew),
          onPressed: dbClear,
        ),
      ]),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('메모메모',
                  style: TextStyle(fontSize: 36, color: Colors.blue)),
            ),
          ),
          Expanded(child: memoBuilder(context)),
          // 알람 화면을 띄울때, 가장 바깥쪽 context에서 띄워야 우리가 원하는 알람창의 형태가 된다.
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      WritePage(updateScreen_home: screenUpdate)));
        },
        tooltip: '메모를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget memoBuilder(BuildContext context_home) {
    return FutureBuilder(
      future: loadMemo(),
      builder: (context, projectSnap) {
        if (projectSnap.data.isEmpty) {
          return Container(
              alignment: Alignment.center,
              child: Text(
                "지금 바로 '메모 추가' 버튼을 눌러 \n새로운 메모를 추가해보세요.\n\n\n\n\n\n\n\n\n\n\n",
                style: TextStyle(fontSize: 15, color: Colors.black12),
                textAlign: TextAlign.center,
              ));
        }
        return Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                Memo memo = projectSnap.data[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context_home,
                        CupertinoPageRoute(
                            builder: (context) => ViewPage(memo.id,
                                updateScreen_home:
                                    screenUpdate)) // 전체 context가 다 옮겨가는 개념!!
                        );
                  },
                  onLongPress: () {
                    delete_id = memo.id;
                    showAlertDialog(context_home);
                    // delete_id = ''; showAlertDialog 가 비동기로 작용하기 때문에 delete할 id가 존재하지 않게 되어버리는 것.
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: const EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 3)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 30,
                              child: Text(
                                memo.title,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              height: 16,
                              child: Text(
                                memo.text,
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 15,
                                child: Text(
                                  "최종 수정 시간 : " + memo.editTime.split('.')[0],
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black26),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]),
                      ],
                    ),
                  ),
                );
              },
            ));
      },

    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();

    return await sd.memos();
  }

  void screenUpdate() {
    setState(() {});
  }

  void dbClear() {
    setState(() {
      DBHelper sd = DBHelper();
      sd.clearMemo();
    });
  }

  void deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
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
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(delete_id);
                });
                delete_id = '';
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                delete_id = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }
}
