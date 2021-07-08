import 'package:flutter/material.dart';

class RoundedRectangleButton extends StatelessWidget {
  const RoundedRectangleButton({
    Key key,
    @required this.text,
    @required this.accentColor,
    @required this.onPressed

  }) : super(key: key);


  final Color accentColor;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 60.0,
        width: 230.0,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: accentColor,
                borderRadius:
                BorderRadius.all(Radius.circular(10.0))),
            child: new Center(
              child: new Text(
                text,
                style:
                TextStyle(color: Colors.white, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            )
        ),
      ),
    );
  }
}