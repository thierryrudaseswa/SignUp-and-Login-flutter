import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirder/Service/Auth_Service.dart';
import 'package:thirder/main.dart';
import 'package:thirder/pages/AddTodo.dart';
import 'package:thirder/pages/SignUpPage.dart';
import 'package:thirder/pages/TodoCart.dart';
import 'package:thirder/pages/profile.dart';
import 'package:thirder/pages/view_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<DocumentSnapshot> _stream = FirebaseFirestore.instance
      .collection("Todo")
      .doc("document_id_here")
      .snapshots();
  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => Profile()),
                (route) => false,
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
          ),
          SizedBox(width: 25),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monday 21",
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var instance =
                          FirebaseFirestore.instance.collection("Todo");
                      for (int i = 0; i < selected.length; i++) {
                        if (selected[i].checkvalue) {
                          instance.doc(selected[i].id).delete();
                        }
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.green,
                      size: 28,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AddTodoPage()),
                  (route) => false,
                );
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.indigoAccent, Colors.purple],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                ),
              ),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
            ),
            label: 'Settings',
          )
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          IconData iconData;
          Color iconColor;
          Map<String, dynamic> document =
              snapshot.data!.data() as Map<String, dynamic>;
          switch (document["category"]) {
            case "Work":
              iconData = Icons.run_circle_outlined;
              iconColor = Colors.white;
              break;
            case "WorkOut":
              iconData = Icons.alarm;
              iconColor = Colors.teal;
              break;
            case "Food":
              iconData = Icons.local_grocery_store;
              iconColor = Colors.blue;
              break;
            case "Design":
              iconData = Icons.audiotrack;
              iconColor = Colors.green;
              break;
            default:
              iconData = Icons.run_circle_outlined;
              iconColor = Colors.red;
          }
          selected.add(
              Select(id: snapshot.data!.id ?? "defaultId", checkvalue: false));
          return ListView.builder(
            itemCount: 1, // Assuming only one document snapshot
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ViewData(
                        document: document,
                        id: snapshot.data!.id ?? "defaultId",
                      ),
                    ),
                  );
                },
                child: TodoCard(
                  title: document["title"] == null
                      ? "Hii There"
                      : document["title"],
                  check: selected[index].checkvalue,
                  iconBgColor: Colors.white,
                  iconColor: iconColor,
                  iconData: iconData,
                  time: "11 PM",
                  index: index,
                  onChange: onChange,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkvalue = !selected[index].checkvalue;
    });
  }
}

class Select {
  String id;
  bool checkvalue = false;
  Select({required this.id, required this.checkvalue});
}
