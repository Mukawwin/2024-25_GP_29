import 'package:flutter/material.dart';
import 'package:mukawwin_3/Widget/alert.dart';

List<Alert> allalert = [
  Alert(
    checkallregies: false,
    button: true,
    title: 'Product is safe',
    desc: 'The Product has no allergies for you. \n safe to consume!',
    icon: Icons.check_circle_outline,
    color: const Color(0xff4B7E80),
    towbutton1: 'Scan again',
    towbutton2: 'Add to safe list',
  ),
  Alert(
    checkallregies: true,
    button: false,
    title: 'Product is unsafe',
    desc:
        'this Product has ingredients that may trigger your allergies Avoid for safety!',
    icon: Icons.hide_source_sharp,
    color: Colors.red,
    onebutton: 'Scan again',
    allergies: const ['egg', 'suger'],
  ),
  Alert(
    checkallregies: false,
    button: false,
    title: 'Image not clear',
    color: Colors.yellow,
    desc:
        "We couldn't read the ingredients. Please retake the picture and ensure the text is clear for accurate result",
    icon: Icons.warning_amber,
    onebutton: 'Scan again',
  )
];

Widget returAlert(int select, List<String> allergies) {
  if (select == 1) {
    return Alert(
      checkallregies: true,
      button: false,
      title: 'Product is unsafe',
      desc:
          'this Product has ingredients that may trigger your allergies Avoid for safety!',
      icon: Icons.hide_source_sharp,
      color: Colors.red,
      onebutton: 'Scan again',
      allergies: allergies,
    );
  } else if (select == 0) {
    return allalert[0];
  } else {
    return allalert[2];
  }
}

SimpleAlert(String des) => Alert(
      checkallregies: false,
      button: true,
      title: 'This is the response from OCR',
      desc: des,
      icon: Icons.check_circle_outline,
      color: const Color(0xff4B7E80),
      towbutton1: 'Scan again',
      towbutton2: 'Add to safe list',
    );
