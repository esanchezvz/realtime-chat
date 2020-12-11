import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.icon,
    @required this.placeholder,
    @required this.textController,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.inputAction = TextInputAction.next,
    this.onSubmitted,
  }) : super(key: key);

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final Function(String) onSubmitted;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5,
          )
        ],
      ),
      child: TextField(
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyboardType,
        obscureText: this.obscure,
        textInputAction: this.inputAction,
        onSubmitted: this.onSubmitted,
        decoration: InputDecoration(
          prefixIcon: Icon(this.icon),
          border: InputBorder.none,
          hintText: this.placeholder,
          contentPadding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
            right: 20.0,
          ),
        ),
      ),
    );
  }
}
