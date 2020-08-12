import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';

class SocialNetworkButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final bool loginInProgress;

  const SocialNetworkButton({
    Key key,
    this.text,
    this.color,
    this.onPressed,
    this.loginInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: color,
      disabledColor: Color(0x61000000),
      textColor: Colors.white,
      onPressed: FormUtil.getFunctionDependingOnEnableState(
        loginInProgress,
        onPressed,
      ),
      child: Container(
        height: ScreenUtil().setHeight(48),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: loginInProgress ? Color(0xafffffff) : Colors.white,
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
