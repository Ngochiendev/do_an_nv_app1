import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/catagories.dart';

class CatagorySnapshot{
  CatagoryDoc doc;
  DocumentReference reference;
  CatagorySnapshot({this.doc, this.reference});

  CatagorySnapshot.fromSnapshot(DocumentSnapshot snapshot):
        doc = CatagoryDoc.fromJson(snapshot.data()),
        reference = snapshot.reference;
}