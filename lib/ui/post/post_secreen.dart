import 'package:doctor_app/firebase_services/firebase_table.dart';
import 'package:doctor_app/ui/auth/login_secreen.dart';
import 'package:doctor_app/ui/post/add_post_secreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../util/utils.dart';
import '../upload_image.dart';

class PostSecreen extends StatefulWidget {
  const PostSecreen({super.key});

  @override
  State<PostSecreen> createState() => _PostSecreenState();
}

class _PostSecreenState extends State<PostSecreen> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
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
          const SizedBox(width: 10),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'search',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: FirebaseAnimatedList(
              query: postTable.child('comment'),
              defaultChild: Center(
                child: Text('Loading'),
              ),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDiloge(title,
                                        snapshot.child('id').value.toString());
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
                                    postTable
                                        .child('comment')
                                        .child(snapshot
                                            .child('id')
                                            .value
                                            .toString())
                                        .remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                            ]),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddPostSecreen()));
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
                    postTable
                        .child('comment')
                        .child(id)
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

//  Expanded(
//             child: StreamBuilder(
//                 stream: postTable.child('comment').onValue,
//                 builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                   if (!snapshot.hasData) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<dynamic, dynamic> map =
//                         snapshot.data!.snapshot.value as dynamic;
//                     List<dynamic> list = [];
//                     list.clear();
//                     list = map.values.toList();
//                     return ListView.builder(
//                         itemCount: snapshot.data!.snapshot.children.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(list[index]['title']),
//                             subtitle: Text(list[index]['id']),
//                           );
//                         });
//                   }
//                 })),
