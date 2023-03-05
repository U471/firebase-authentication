import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/firebase_services/firebase_table.dart';
import 'package:doctor_app/ui/auth/login_secreen.dart';
import 'package:doctor_app/ui/firestore/firestore_add_secreen.dart';
import 'package:doctor_app/ui/post/add_post_secreen.dart';
import 'package:doctor_app/ui/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../util/utils.dart';

class FireStoreSecreen extends StatefulWidget {
  const FireStoreSecreen({super.key});

  @override
  State<FireStoreSecreen> createState() => _FireStoreSecreenState();
}

class _FireStoreSecreenState extends State<FireStoreSecreen> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginSecreen()));
                }).onError((error, stackTrace) {
                  String message = error.toString();
                  List<String> parts = message.split("] ");
                  debugPrint(parts[1]);
                  Utils().toastMessage(parts[1]);
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImageUploadSecreen()));
              },
              icon: Icon(Icons.image_outlined)),
          const SizedBox(width: 10)
        ],
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'search',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: postfirestoreTable.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    // final title = snapshot.data!.docs.toString();

                    // Map<dynamic, dynamic> map =
                    //     snapshot.data!.docs as dynamic;
                    // List<dynamic> list = [];
                    // list.clear();
                    // list = map.values.toList();
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final title =
                              snapshot.data!.docs[index]['title'].toString();
                          if (searchController.text.isEmpty) {
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title']
                                  .toString()),
                              subtitle: Text(snapshot.data!.docs[index].id),
                              trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDiloge(
                                                  title,
                                                  snapshot
                                                      .data!.docs[index].id);
                                            },
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              postfirestoreTable
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                            },
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                          ),
                                        ),
                                      ]),
                            );
                          } else if (title.toLowerCase().contains(
                              searchController.text.toLowerCase().toString())) {
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title']
                                  .toString()),
                              subtitle: Text(snapshot.data!.docs[index].id),
                            );
                          } else {
                            return Container();
                          }
                        });
                  }
                })),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFirestoreSecreen()));
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<void> showDiloge(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancle')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    postfirestoreTable
                        .doc(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().toastMessageSuccess('Post updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
