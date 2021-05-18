import 'package:do_an_nv_app/datas/data.dart';
import 'package:do_an_nv_app/datas/fake_datas.dart';
import 'package:do_an_nv_app/modules/catagories.dart';
import 'package:do_an_nv_app/widget/catagory_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CatagorySection extends StatefulWidget {
  final ValueChanged<String> voidCallback;
  CatagorySection({this.voidCallback});
  @override
  _CatagorySectionState createState() => _CatagorySectionState(voidCallback: voidCallback);
}

class _CatagorySectionState extends State<CatagorySection> {
  final ValueChanged<String> voidCallback;
  _CatagorySectionState({this.voidCallback});
  // List<Beverages> beverages;
  // List<Beverages> beveragesForDisPlay;
  String catagoryID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catagoryID = '';
  }
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseCatagory fireStoreDatabaseCatagory = Provider.of<FireStoreDatabaseCatagory>(context);
    return Container(
        padding: EdgeInsets.only(top: 7, bottom: 7),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10),
              child: Center(child: Text('Danh mục',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45),),),),
            Container(
              height: 150,
              child: StreamBuilder<List<CatagorySnapshot>>(
                stream: fireStoreDatabaseCatagory.getCatagoryFromFireBase(),
                builder: (context, snapshot){
                  if(snapshot.hasData)
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, catagoryIndex){
                        CatagoryDoc _catagory = snapshot.data[catagoryIndex].doc;
                        return InkWell(
                            child: CatagoryItemPage(
                              iconData: catagoryID == _catagory.id ? Icons.check : catagoryIcons[_catagory.icon],
                              name: _catagory.name,
                              colors: catagoryColors[_catagory.id],
                            ),
                            splashColor: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                            onTap: (){
                              voidCallback(_catagory.id);
                              setState(() {
                                if (catagoryID == _catagory.id) {
                                  // beverages = FAKE_BEVERAGES.toList();
                                  // beveragesForDisPlay = beverages;
                                  catagoryID = '';
                                } else {
                                  catagoryID = _catagory.id;
                                  // beverages = FAKE_BEVERAGES.where((beverage) => beverage.catagoryId == _catagory.id).toList();
                                  // beveragesForDisPlay = beverages;
                                }
                              });
                            }
                        );
                      },
                    );
                  return Center(child: CircularProgressIndicator());

                },
              ),
            ),
          ],
        )
    );
  }
}

