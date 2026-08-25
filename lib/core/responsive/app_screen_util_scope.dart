import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_design_size.dart';

class AppScreenUtilScope extends StatelessWidget {
  const AppScreenUtilScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDesignSize.canvas,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => child!,
      child: child,
    );
  }
}
