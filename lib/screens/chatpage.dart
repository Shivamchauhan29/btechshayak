import 'package:btechshayak/screens/messagetile.dart';
import 'package:btechshayak/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final String? userName;
  const ChatPage(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messaagesController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
  }

  getChatandAdmin() async {
    var chatResult = await DataBaseService().getChats(widget.groupId ?? '');
    if (chatResult != null) {
      setState(() {
        chats = chatResult;
      });
    }

    var adminResult =
        await DataBaseService().getGroupAdmin(widget.groupId ?? '');
    if (adminResult != null) {
      setState(() {
        admin = adminResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).unfocus(),
      },
      onVerticalDragDown: (details) => {
        FocusScope.of(context).unfocus(),
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('${widget.groupName}'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  // nextScreen(
                  //     context,
                  //     GroupInfo(
                  //       groupId: widget.groupId,
                  //       groupName: widget.groupName,
                  //       adminName: admin,
                  //     ));
                },
                icon: const Icon(Icons.info_outline))
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: chatMessages(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messaagesController,
                        decoration: const InputDecoration(
                          hintText: "Let's chat!!!",
                          border: OutlineInputBorder(),
                        ),
                      )),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                  );
                },
              )
            : Container();
      },
      stream: chats,
    );
  }

  sendMessage() {
    if (messaagesController.text.isNotEmpty) {
      print('sending message ');
      Map<String, dynamic> chatMessageMap = {
        "message": messaagesController.text,
        "sender": widget.userName ?? 'Shivam',
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DataBaseService().sendMessage(widget.groupId ?? 'shivam Group', chatMessageMap);
      setState(() {
        messaagesController.clear();
      });
    }
  }
}
