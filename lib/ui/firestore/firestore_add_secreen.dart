import 'package:doctor_app/firebase_services/firebase_table.dart';
import 'package:doctor_app/util/utils.dart';
import 'package:doctor_app/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFirestoreSecreen extends StatefulWidget {
  const AddFirestoreSecreen({super.key});

  @override
  State<AddFirestoreSecreen> createState() => _AddFirestoreSecreenState();
}

class _AddFirestoreSecreenState extends State<AddFirestoreSecreen> {
  // final firestore = FirebaseFirestore.instance.collection('user');
  TextEditingController postcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add FireStore Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: postcontroller,
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: 'What is the name of the post',
                    border: const OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a post text";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: "Add",
                loading: loading,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    addPost();
                  }
                })
          ],
        ),
      ),
    );
  }

  void addPost() {
    setState(() {
      loading = true;
    });
    //unique id genrate => DataTime.now().millisecondsSinceEpoch.toString()                   postTable.child('Items').child('comment').push().set({
    // String id = DateTime.now().millisecondsSinceEpoch.toString();
    postfirestoreTable
        .add({'title': postcontroller.text.toString()}).then((documentRef) {
      String docId = documentRef.id;
      postfirestoreTable.doc(docId).update({'id': docId});
      postcontroller.clear();
      Utils().toastMessageSuccess('Post Add');
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
    // postfirestoreTable
    //     .doc()
    //     .set({'title': postcontroller.text.toString()}).then((value) {
    //   postfirestoreTable.doc(value.id).update({'id': value.id});
    //   postcontroller.clear();
    //   Utils().toastMessageSuccess('Post Add');
    //   setState(() {
    //     loading = false;
    //   });
    // }).onError((error, stackTrace) {});
    // postTable.child('comment').child(id).set({
    //   'id': id,
    //   'title': postcontroller.text.toString(),
    // }).then((value) {
    //   // var newCommentKey = value.key.toString();
    //   // print(newCommentKey);
    //   postcontroller.clear();
    //   Utils().toastMessageSuccess('Post Add');
    //   setState(() {
    //     loading = false;
    //   });
    // }).onError((error, stackTrace) {
    //   Utils().toastMessage(error.toString());
    //   setState(() {
    //     loading = false;
    //   });
    // });
  }
}
