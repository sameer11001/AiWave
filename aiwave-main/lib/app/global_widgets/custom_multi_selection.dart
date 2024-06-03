import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CustomMultiSelection extends StatefulWidget {
  final List<MultiSelectItem<dynamic>> items;
  final Function(dynamic)? onChanged;
  final bool withSearchBox;
  const CustomMultiSelection(
      {super.key,
      required this.items,
      this.onChanged,
      this.withSearchBox = true});

  @override
  State<CustomMultiSelection> createState() => _CustomMultiSelectionState();
}

class _CustomMultiSelectionState extends State<CustomMultiSelection> {
  late TextEditingController textEditingController;
 

  @override
  void initState() {
    super.initState();

    // Initialize the text editing controller
    textEditingController = TextEditingController();
    // Set the initial value if there is one
    
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                MultiSelectDialogField(
                  searchable: widget.withSearchBox,
                  items: widget.items,
                  title: const Text("Animals"),
                  onConfirm: (results) {
                   widget.onChanged;
                  },
                  searchHint: "Search for an ",
                ),
                const SizedBox(height: 50),
              ],
            )));
  }
}
