// taken from https://stackoverflow.com/a/59512876
import 'package:flutter/material.dart';

class AnimatedListItem extends StatefulWidget {
  final Widget item;

  AnimatedListItem(this.item);

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _lock = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((Duration d) {
      setState(() {
        _lock = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 350),
      opacity: _lock ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
          duration: Duration(milliseconds: 150),
          curve: Curves.ease,
          padding: _lock
              ? EdgeInsets.zero
              : EdgeInsets.only(top: MediaQuery.of(context).size.height),
          child: widget.item),
    );
  }
}
