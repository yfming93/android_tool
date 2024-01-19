import 'package:tools/widget/text_view.dart';
import 'package:flutter/material.dart';

class TitleView extends StatefulWidget {
  Color color;
  String title;

  TitleView({Key? key, required this.title, this.color = Colors.black})
      : super(key: key);

  @override
  _TitleViewState createState() => _TitleViewState();
}

class _TitleViewState extends State<TitleView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(5),
            )),
        const SizedBox(width: 5),
        TextView(widget.title),
      ],
    );
  }
}
