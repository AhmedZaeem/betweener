import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class My_Button extends StatefulWidget {
  final Function()? onTap;
  final double buttonRadius;
  final double textPadding;
  final Color? buttonColor;
  final Border? btnBoarder;
  final Color textColor;
  final String buttonText;
  final bool hasShadow;
  final bool hasSplash;
  final bool enabled;
  final double? height;
  final TextStyle? textStyle;
  const My_Button({
    required this.buttonText,
    this.enabled = true,
    this.textStyle,
    this.btnBoarder,
    this.textPadding = 0,
    this.buttonRadius = 16,
    this.hasShadow = false,
    this.hasSplash = true,
    this.height,
    this.textColor = Colors.white,
    this.buttonColor,
    this.onTap,
    super.key,
  });

  @override
  State<My_Button> createState() => _My_ButtonState();
}

class _My_ButtonState extends State<My_Button> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: !widget.hasSplash
          ? Colors.transparent
          : Theme.of(context).colorScheme.primary,
      highlightColor: !widget.hasSplash
          ? Colors.transparent
          : Theme.of(context).colorScheme.primary,
      onTap: widget.enabled ? widget.onTap : null,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: widget.btnBoarder,
          boxShadow: widget.hasShadow
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.3),
                    offset: const Offset(0, 7),
                    blurStyle: BlurStyle.inner,
                    blurRadius: 80.r,
                    spreadRadius: .5,
                  )
                ]
              : null,
          color: !widget.enabled
              ? Theme.of(context).colorScheme.onSurface
              : widget.buttonColor ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(widget.buttonRadius.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.textPadding),
          child: Text(
            widget.buttonText,
            style: widget.textStyle ??
                TextStyle(
                  fontSize: 20.sp,
                  color: !widget.enabled
                      ? Theme.of(context).colorScheme.onBackground
                      : widget.textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
