import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../get/controller.dart';

List<String> items = [
  'My Document',
  'Horizontal',
  'Vertical',
  'Note',
  'My Notes'
];

class PopupMenuBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (menu) => PopupMenuButton(
          elevation: 20,
          onSelected: (String _value) {
            switch (_value) {
              case 'Horizontal':
                Future.delayed(const Duration(milliseconds: 200), () {
                  menu.ChangingDirection('Horizontal');
                });

                break;
              case 'Vertical':
                Future.delayed(const Duration(milliseconds: 200),() {
                  menu.ChangingDirection('Vertical');
                });
                break;
              case 'Note':
                Future.delayed(const Duration(milliseconds: 200), () {
                  menu.showBottomSheet(context);
                });
                break;
              case 'My Notes':
                Future.delayed(const Duration(milliseconds: 200),() {
                  Get.toNamed('/fifth');
                });
                break;
              case 'My Document':
                Future.delayed(const Duration(milliseconds: 200), () {
                  Get.offNamed('home');
                });
                break;
            }
          },
          itemBuilder: (BuildContext context) => items.map((String values) {
            return PopupMenuItem(value: values, child: Text(values));
          }).toList()),
    );
  }
}

