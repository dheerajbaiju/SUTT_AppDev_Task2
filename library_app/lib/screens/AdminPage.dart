import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final controllerName = TextEditingController();
  final controllerStatus = TextEditingController();
  final controllerTitle = TextEditingController();

  final updatecontrollerName = TextEditingController();
  final updatecontrollerStatus = TextEditingController();
  final updatecontrollerTitle = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Books');

  @override
  Widget build(BuildContext context) {
    Future<void> _delete(String productId) async {
      await _products.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You have successfully deleted a product')));
    }

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        updatecontrollerTitle.text = documentSnapshot['Enter title of book'];

        updatecontrollerName.text = documentSnapshot['Enter name of author'];
        updatecontrollerStatus.text =
            documentSnapshot['Enter the availability status of book']
                .toString();
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: updatecontrollerTitle,
                    decoration:
                        const InputDecoration(labelText: 'Enter title of book'),
                  ),
                  TextField(
                    controller: updatecontrollerName,
                    decoration: const InputDecoration(
                        labelText: 'Enter name of author'),
                  ),
                  TextField(
                    controller: updatecontrollerStatus,
                    decoration: const InputDecoration(
                        labelText: 'Enter availability status of book'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String uname = updatecontrollerName.text;
                        final String ustatus = updatecontrollerStatus.text;
                        final String utitle = updatecontrollerTitle.text;

                        await _products.doc(documentSnapshot!.id).update({
                          "name": uname,
                          "Availability Status": ustatus,
                          "Book Title": utitle
                        });
                        updatecontrollerTitle.text = '';

                        updatecontrollerName.text = '';
                        Navigator.of(context).pop();
                      })
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN PAGE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(children: [
          Text('ADD BOOK'),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(labelText: 'Enter title of book'),
          ),
          TextField(
            controller: controllerTitle,
            decoration: InputDecoration(labelText: 'Enter name of author'),
          ),
          TextField(
            controller: controllerStatus,
            decoration:
                InputDecoration(labelText: 'Enter availability status of book'),
          ),
          ElevatedButton(
              onPressed: () {
                final name = controllerName.text;
                var status = (controllerStatus.text);
                final title = controllerTitle.text;
                add(name, status, title);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You have successfully added a book')));
              },
              child: Text('Enter')),
          Text('BOOK LIST'),
          StreamBuilder(
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
                        title: Text(
                          'Book title: ' + documentSnapshot['Book Title'],
                          style: TextStyle(fontSize: 10),
                        ),
                        subtitle: Text(
                          'Name of book :' +
                              documentSnapshot['Book Title'] +
                              'Name of Author: ' +
                              documentSnapshot['name'],
                          style: TextStyle(fontSize: 10),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _update(documentSnapshot)),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text('loading');
              }
            },
          )
        ]),
      ),
    );
  }
}

Future add(String name, String status, String title) async {
  final docUser = FirebaseFirestore.instance.collection('Books').doc();

  final user = User(
    id: docUser.id,
    name: name,
    status: status,
    title: title,
  );

  final json = user.toJson();

  await docUser.set(json);
}

class User {
  String id;
  final String name;
  final String status;
  final String title;

  User({
    this.id = '',
    required this.name,
    required this.status,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'Availability Status': status,
        'Book Title': title,
      };
}
