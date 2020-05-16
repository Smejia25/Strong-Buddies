import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(243),
        child: SelectableText(
          'By clicking start, you agree to our Terms and Conditions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(15),
            letterSpacing: -0.36,
            height: 1.46,
          ),
        ),
      ),
    );
  }
}
