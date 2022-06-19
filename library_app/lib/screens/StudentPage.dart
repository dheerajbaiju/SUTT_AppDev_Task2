import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<StudentPage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Books');

  bool checkBoxValue = false;
  final controllerStatus = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Page"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Book title: ' +
                        documentSnapshot['name'] +
                        documentSnapshot['Book Title']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(children: [
                        Checkbox(
                            value: checkBoxValue,
                            onChanged: (bool? value) {
                              setState(() {
                                checkBoxValue = value!;
                                print(checkBoxValue);

                                if (documentSnapshot != null) {
                                  controllerStatus.text =
                                      documentSnapshot['Availability Status'];
                                }

                                final String ustatus = controllerStatus.text;

                                _products.doc(documentSnapshot.id).update({
                                  "Availability Status": checkBoxValue,
                                });
                              });
                            })
                      ]),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('loading');
          }
        },
      ),
    );
  }
}
