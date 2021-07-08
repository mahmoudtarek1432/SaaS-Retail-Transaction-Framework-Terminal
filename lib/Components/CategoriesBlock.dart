import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:terminal/Components/ImageBlock.dart';

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    Key key,

    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.textColor,
    @required this.categoryID,
    @required this.categoryName,
    @required this.categoryImage,
    @required this.onPressed,


  }) : super(key: key);

  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final String categoryID;
  final String categoryName;
  final String categoryImage;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200.0,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color:primaryColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ImageBlock(width: 100, height: 80,image: categoryImage, secondaryColor: secondaryColor),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: new Text(
                      categoryName,
                      style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

