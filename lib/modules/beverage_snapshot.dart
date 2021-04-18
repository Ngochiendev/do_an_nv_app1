import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_nv_app/modules/beverages.dart';


class BeverageSnapshot{
  Beverages beverages;
  DocumentReference documentReference;
  BeverageSnapshot({this.beverages, this.documentReference});

  BeverageSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      beverages = Beverages.fromJson(snapshot.data()),
      documentReference = snapshot.reference;
}