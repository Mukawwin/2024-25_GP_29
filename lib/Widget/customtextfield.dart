import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Custom_TextField extends StatefulWidget {
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  late bool? obscure;

  final IconData icon;
  final String hinttext;
  Custom_TextField({
    super.key,
    required this.icon,
    required this.hinttext,
    required this.mycontroller,
    this.validator,
    this.obscure,
  });

  @override
  State<Custom_TextField> createState() => _Custom_TextFieldState();
}

class _Custom_TextFieldState extends State<Custom_TextField> {
  bool os = true;

  void obs() {
    setState(() {
      os = !os;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 224, 221, 221),
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: TextFormField(
          obscureText: widget.obscure == true ? os : false,
          controller: widget.mycontroller,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.hinttext,
            prefixIcon: Icon(widget.icon, color: Colors.teal),
            suffixIcon: widget.obscure == true
                ? IconButton(
                    icon: os == false
                        ? const Icon(Icons.remove_red_eye)
                        : const Icon(Icons.visibility_off_outlined),
                    onPressed: () {
                      obs();
                    },
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff387f7f), width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          cursorColor: Colors.teal,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonname;
  final void Function()? onPressed;
  const CustomButton(
      {super.key, required this.onPressed, required this.buttonname});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: const Color(0xff387f7f),
      onPressed: onPressed,
      child: Text(
        buttonname,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
