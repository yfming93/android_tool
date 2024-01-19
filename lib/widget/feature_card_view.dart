import 'package:flutter/material.dart';

class FeatureCardView extends StatefulWidget {
  Widget child;
  String title;

  FeatureCardView({required this.child, this.title = '', Key? key})
      : super(key: key);

  @override
  _FeatureCardViewState createState() => _FeatureCardViewState();
}

class _FeatureCardViewState extends State<FeatureCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: widget.child,
      ),
    );
  }
}
