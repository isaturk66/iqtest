import 'package:flutter/material.dart';

designW(double width, BuildContext context) {
  return (width / 375) * MediaQuery.of(context).size.width;
}

designH(double height, BuildContext context) {
  return (height / 782) * MediaQuery.of(context).size.height;
}

designSize(Size size, BuildContext context) {
  return Size(designW(size.width, context), designH(size.height, context));
}
