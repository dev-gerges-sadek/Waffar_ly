import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


extension ContextSizeExtensions on BuildContext {
  double w(double width) => width.w;
  double h(double height) => height.h;
  double sp(double size) => size.sp;
}
