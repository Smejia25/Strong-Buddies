import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/themes/colors.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final _borderRadius = 22.0;
  final _heigth = 48;
  final bool isDisable;

  const PrimaryButton({
    Key key,
    this.child,
    this.onTap,
    this.isDisable = false,
  }) : super(key: key);

  PrimaryButton.text({
    Key key,
    String text,
    this.onTap,
    this.isDisable = false,
  })  : child = Text(
          text,
          style: TextStyle(
            color: isDisable ? Color(0xa1ffffff) : Colors.white,
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.w600,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: isDisable ? null : onTap,
        child: Ink(
          decoration: isDisable
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  color: Color(0x31000000))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  gradient: MainColorGradient,
                ),
          child: Container(
            height: ScreenUtil().setHeight(_heigth),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
