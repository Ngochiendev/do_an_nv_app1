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
    RandomColor _random = RandomColor();
    Color _randomColor = _random.randomColor(
        colorBrightness: ColorBrightness.dark
    );
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
            Padding(padding: EdgeInsets.only(left: 20)),
            Text(name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Pacifico',color: Colors.white),)
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
