import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialNetworkButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const SocialNetworkButton({
    Key key,
    this.text,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: color,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Container(
        height: ScreenUtil().setHeight(48),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
