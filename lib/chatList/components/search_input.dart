
import 'package:flutter/material.dart';

class StatusCircle extends StatelessWidget {
  const StatusCircle({Key key, this.size, this.color}) : super(key: key);
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // Button send image

          // Edit text
          Flexible(
            child: Container(
              height: 50,
              child: TextField(
                onChanged: (text) {
                  print("First text field: $text");
                },
                style: TextStyle(
                  color: Color(0xFF9B9B9B),
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration(
                  fillColor: Color(0xFFE6E6E6),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFC1C0C9)),
                  hintText: 'Search...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  errorBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
        ],
      ),
      width: double.infinity,
      height: 55.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Color(0xFFF8F8F8)),
    );
  }