import 'package:flutter/material.dart';
import 'package:terminal/constant.dart';

class ImageBlock extends StatelessWidget {
  const ImageBlock({
    Key key,
    @required this.height,
    @required this.width,
    @required this.image,
    @required this.secondaryColor,
  }) : super(key: key);

  final double height;
  final double width;
  final String image;
  final Color secondaryColor;



  @override
  Widget build(BuildContext context) {

    return Container(
      height: height,
      width: width,
      color: Colors.transparent,
      child: Container(
        decoration: image == "" ? BoxDecoration(
            color: secondaryColor,
            borderRadius:
            BorderRadius.all(
                Radius.circular(
                    12.0
                )
            )
        )
            : BoxDecoration(
            image:  DecorationImage(
                fit:  BoxFit.fill,
                image: NetworkImage("$baseurl/images/$image")
            ),
            color: secondaryColor,
            borderRadius:
            BorderRadius.all(
                Radius.circular(
                    12.0
                )
            )
        ),
      ),
    );
  }
}