import 'package:flutter/material.dart';

class SelectionCard extends StatefulWidget {
  const SelectionCard({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.initialValue,
  })  : this.isWithController = false,
        this.condition = null,
        this.stream = null,
        super(key: key);

  const SelectionCard.withStreamController({
    Key key,
    @required this.child,
    @required this.onPressed,
    @required this.condition,
    @required this.stream,
    this.initialValue,
  })  : this.isWithController = true,
        super(key: key);

  final child;
  final Stream<void> stream;
  final bool Function() condition;
  final void Function(bool currentState) onPressed;
  final bool initialValue;
  final bool isWithController;

  @override
  _SelectionCardState createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Positioned(child: widget.child),
          Positioned(
              top: 12,
              right: 15,
              child: getWidgetBasedOnWhichConstructerWasUsed())
        ],
      ),
      onTap: handleTap,
    );
  }

  void handleTap() {
    _isSelected = !_isSelected;
    if (!widget.isWithController) setState(() {});
    widget.onPressed(_isSelected);
  }

  Widget getWidgetBasedOnWhichConstructerWasUsed() => widget.isWithController
      ? buildStreamBuilder()
      : buildCheckBoxAnimatedCheckBox();

  StreamBuilder<void> buildStreamBuilder() {
    return StreamBuilder<void>(
      stream: widget.stream,
      builder: (context, snapshot) {
        _isSelected = widget.condition();
        return buildCheckBoxAnimatedCheckBox();
      },
    );
  }

  AnimatedOpacity buildCheckBoxAnimatedCheckBox() {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        opacity: _isSelected ? 1 : 0,
        child: const CheckMark());
  }
}

class CheckMark extends StatelessWidget {
  const CheckMark({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xFF287336)),
      child: Icon(Icons.check, color: Colors.white, size: 20.0),
    );
  }
}
