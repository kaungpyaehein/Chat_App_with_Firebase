import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions.dart';

Text buildTitleText(String label) {
  return Text(
    label,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: kTextHeading1X,
      fontWeight: FontWeight.bold,
    ),
  );
}

AppBar buildDefaultAppBar(String title, bool isShowLeading) {
  return AppBar(
    automaticallyImplyLeading: isShowLeading,
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        color: kDefaultBlackColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
