import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EcoTextField extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  String? Function(String?)? validate;
  Widget? icon;
  bool isPassword;
  bool check;
  int? maxLines;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final String? labelText;
  bool enabled;
  void Function(String)? onChanged; // Nullable onChanged callback

  EcoTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.validate,
    this.icon,
    this.isPassword = false,
    this.check = false,
    this.maxLines,
    this.inputAction,
    this.focusNode,
    this.labelText,
    this.enabled = true,
    this.onChanged, // Nullable onChanged callback
  }) : super(key: key);

  @override
  State<EcoTextField> createState() => _EcoTextFieldState();
}

class _EcoTextFieldState extends State<EcoTextField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        // Wrap the TextFormField inside a Column
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null) // Show the labelText if provided
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                widget.labelText!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          TextFormField(
            enabled: widget.enabled,
            maxLines: widget.maxLines == 1 ? 1 : widget.maxLines,
            focusNode: widget.focusNode,
            textInputAction: widget.inputAction,
            controller: widget.controller,
            obscureText: widget.isPassword == false ? false : widget.isPassword,
            validator: widget.validate,
            onChanged: widget.onChanged, // Pass the onChanged callback
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText ?? 'hint Text...',
              suffixIcon: widget.icon,
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
