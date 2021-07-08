import 'package:flutter/material.dart';
import 'package:terminal/constant.dart';

class RadioTextButton extends StatelessWidget {

  final Color accentColor;
  final Color textColor;
  final String label;
  final int selectedRadio;
  final Function onPressed;
  final int value;
  final String id;

  RadioTextButton({
    Key key,
    @required this.label,
    @required this.onPressed,
    @required this.value,
    @required this.textColor,
    @required this.accentColor,
    @required this.selectedRadio,
    @required this.id
  }
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: kItemNameStyle.copyWith(fontSize: 25.0, color: textColor),
          ),
          Transform.scale(
            scale: 1.5,
            child: Radio(
              value: value,
              groupValue: selectedRadio,
              onChanged: onPressed,
              activeColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
