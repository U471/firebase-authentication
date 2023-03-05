import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DatabaseReference postTable =
    FirebaseDatabase.instance.ref(); // realtime table instance
CollectionReference postfirestoreTable =
    FirebaseFirestore.instance.collection('user');
