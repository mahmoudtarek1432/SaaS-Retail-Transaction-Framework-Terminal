import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    @required this.accentColor,
    @required this.icon,
    @required this.onPressed
  });
  final Color accentColor;
  final IconData icon;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon,
      color: Colors.white,
      ),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        height: 56.0,
        width: 56.0,
      ),
      fillColor: accentColor,
      shape: CircleBorder(),
    );
  }
}
