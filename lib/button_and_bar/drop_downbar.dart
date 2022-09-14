import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../get/controller.dart';

String chosenvalue = 'English_to_Myanmar';

class DropDownBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        builder: (dropdown) => DropdownButtonHideUnderline(
              child: Container(
                  child: DropdownButton(
                      value: chosenvalue,
                      style: TextStyle(color: Color(0xFF2E72C9), fontWeight: FontWeight.bold),
                      items: <String>[
                        'English_to_Myanmar',
                        'Japanese_to_English',
                        'Cambridge_Dictionary',
                        'Korean_to_English',
                        'Chinese_to_English',
                        'Google_Search',
                        'Google_Translate',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        dropdown.ChangingValue(value);
                      })),
            ));
  }
}
