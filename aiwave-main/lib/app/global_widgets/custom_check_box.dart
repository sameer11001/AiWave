import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String text;
  final bool initialValue;
  final Function(bool) onChanged;

  const CustomCheckBox({
    super.key,
    required this.text,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value!;
            });
            widget.onChanged(value!);
          },
        ),
        const SizedBox(width: 8.0),
        Expanded(child: Text(widget.text)),
      ],
    );
  }
}
