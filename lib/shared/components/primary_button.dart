import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final _borderRadius = 22.0;
  final _heigth = 48;
  final _gradient = const LinearGradient(
    colors: <Color>[
      Color(0xffff8960),
      Color(0xffff62a5),
    ],
    stops: [0.2571, 0.908],
    begin: Alignment(0, 1.2),
    end: Alignment(-1.49, 0),
  );

  const PrimaryButton({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);

  PrimaryButton.text({
    Key key,
    String text,
    this.onTap,
  })  : child = Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.w600,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            gradient: _gradient,
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
