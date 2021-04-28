import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
class CatagoryItemPage extends StatelessWidget {
  final Color colors;
  final IconData iconData;
  final String name;
  CatagoryItemPage({
    @required this.colors,
    @required this.iconData,
    @required this.name
});
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/1000;

    RandomColor _random = RandomColor();
    Color _randomColor = _random.randomColor(
        colorBrightness: ColorBrightness.dark
    );
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: size*450,
        height: size*300,
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
              size: size*80,
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Container(
                height: size*110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(name,
                      style: TextStyle(
                          fontSize: size*60,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',color: Colors.white
                      ),)
                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: colors ?? _randomColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: 4,
                  offset: Offset(3,6)
              )
            ]
        ),
      ),
    );
  }
}
