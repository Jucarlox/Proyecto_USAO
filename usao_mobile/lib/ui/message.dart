import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usao_mobile/styles/colors.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;

  ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendUid;
  final friendName;

  var chatDocId;
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName);

  Future<String> dosharePreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('id').toString();
  }

  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    dosharePreferences();
    checkUser();
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await chats
        .where('users',
            isEqualTo: {friendUid: null, prefs.getString('id'): null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {prefs.getString('id'): null, friendUid: null}
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': prefs.getString('id'),
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  String modifyMessage(String msg) {
    String result = msg;
    String prueba = msg.replaceAll(' ', 'wz');
    late String result1, result2, result3, result4, result5, result6;
    for (var i = 0; i < prueba.length; i++) {
      if (i == 25) {
        result1 = StringUtils.addCharAtPosition(prueba, '\n', 25);
      }

      if (i == 50) {
        result2 = StringUtils.addCharAtPosition(result1, '\n', 50);
      }
      if (i == 75) {
        result3 = StringUtils.addCharAtPosition(result2, '\n', 75);
      }
      if (i == 100) {
        result4 = StringUtils.addCharAtPosition(result3, '\n', 100);
      }
      if (i == 125) {
        result5 = StringUtils.addCharAtPosition(result4, '\n', 125);
      }
      if (i == 150) {
        result6 = StringUtils.addCharAtPosition(result5, '\n', 150);
      }
    }

    if (prueba.length >= 150) {
      return result6.replaceAll('wz', ' ');
    }
    if (prueba.length >= 125) {
      return result5.replaceAll('wz', ' ');
    }
    if (prueba.length >= 100) {
      return result4.replaceAll('wz', ' ');
    }
    if (prueba.length >= 75) {
      return result3.replaceAll('wz', ' ');
    }
    if (prueba.length >= 50) {
      return result2.replaceAll('wz', ' ');
    }
    if (prueba.length >= 25) {
      return result1.replaceAll('wz', ' ');
    }

    return prueba.replaceAll('wz', ' ');
  }

  bool isSender(String friend) {
    return friend == prefs.getString('id');
  }

  Alignment getAlignment(friend) {
    if (friend == prefs.getString('id')) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading"),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 49, 47, 47),
            appBar: CupertinoNavigationBar(
              middle: Text(friendName),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          data = document.data();
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                nipSize: 0,
                                radius: 0,
                                type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['uid'].toString())
                                  ? Color.fromARGB(255, 202, 245, 169)
                                  : Colors.white,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(data['msg'],
                                            style: GoogleFonts.amiri(
                                                fontSize: 20,
                                                color: Colors.black),
                                            maxLines: 100,
                                            overflow: TextOverflow.ellipsis)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                                  .toDate()
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 8, color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CupertinoTextField(
                            controller: _textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                          child: Icon(Icons.send_sharp),
                          onPressed: () =>
                              sendMessage(modifyMessage(_textController.text)))
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
