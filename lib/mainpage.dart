import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final TextEditingController _name = TextEditingController();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter todo list',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await collectionReference.add(
                      {
                        'name': _name.text,
                      },
                    ).then((value) => _name.clear());
                  },
                  child: Text("Add"),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: collectionReference.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                          children: snapshot.data.docs
                              .map((e) => ListTile(
                                    title: Text(e['name']),
                                    // subtitle: Text(e['email']),
                                  ))
                              .toList());
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
