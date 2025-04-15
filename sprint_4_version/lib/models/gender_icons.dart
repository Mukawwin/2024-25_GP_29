// import 'package:flutter/material.dart';

// class GenderIcons extends StatefulWidget {
//   final String gender;
//   final bool sel;

//   const GenderIcons({super.key, required this.gender, required this.sel});

//   @override
//   State<GenderIcons> createState() => _GenderIconsState();
// }

// class _GenderIconsState extends State<GenderIcons> {
//   Color color = Colors.white;
//   late bool select;
//   @override
//   void initState() {
//     select = widget.sel;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       radius: 25,
//       onTap: () {
//         setState(() {
//           select ? color = Colors.white : color = const Color(0xFFD5F4E0);
//         });
//       },
//       child: Container(
//         // padding: EdgeInsets.all(15),
//         margin: const EdgeInsets.all(15),
//         color: color,
//         height: 150,
//         width: 150,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               offset: const Offset(0, 0),
//             ),
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               spreadRadius: -4,
//               blurRadius: 10,
//               offset: const Offset(5, 5),
//             ),
//             const BoxShadow(
//               color: Colors.white,
//               spreadRadius: -5,
//               blurRadius: 10,
//               offset: Offset(0, -10),
//             ),
//           ],
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Center(
//           child: SizedBox(
//               height: 100, width: 100, child: Image.asset(widget.gender)),
//         ),
//       ),
//     );
//   }
// }
