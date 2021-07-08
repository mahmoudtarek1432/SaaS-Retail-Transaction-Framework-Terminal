import 'package:flutter/material.dart';

class SectionName extends StatelessWidget {
  const SectionName({
    Key key,
    @required this.labelColor,
    @required this.sectionLabel,
  }) : super(key: key);

  final Color labelColor;
  final String sectionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          sectionLabel,
          style: TextStyle(
            fontSize: 40.0,
            color: labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
