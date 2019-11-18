import 'package:flutter/material.dart';

class SelectiveCard extends StatelessWidget {
  const SelectiveCard({
    Key key,
    @required this.iconFile,
    @required this.cardLabel,
    @required this.onPressed,
    @required this.isSelected,
  }) : super(key: key);

  final String iconFile;
  final String cardLabel;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
            aspectRatio: 1,
            child: Card(
                color: Colors.white,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      onTap: onPressed,
                      child: Container(
                        child: Stack(children: <Widget>[
                          Positioned.fill(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(iconFile))),
                          if (isSelected) ...[
                            Positioned(
                              top: 5,
                              right: 10,
                              child: Icon(Icons.done_outline,
                                  color: Theme.of(context).primaryColor),
                            )
                          ]
                        ]),
                      )),
                ))),
        SizedBox(height: 10),
        Text(cardLabel,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xffCECECE)))
      ],
    );
  }
}

/* class _SelectiveCardState extends State<SelectiveCard> {
  bool _isSelected = false;
  void _changeSelectionState() {
    widget.onPressed();
    setState(() => _isSelected = !_isSelected);
  }
}
 */
