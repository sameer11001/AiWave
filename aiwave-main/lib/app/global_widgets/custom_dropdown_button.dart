
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final bool withSearchBox;
  const CustomDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.withSearchBox = false,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late TextEditingController textEditingController;
  dynamic value;

  @override
  void initState() {
    super.initState();

    // Initialize the text editing controller
    textEditingController = TextEditingController();
    // Set the initial value if there is one
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: value,
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(.8),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(.9),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ),
        items: widget.items,
        dropdownSearchData: widget.withSearchBox
            ? DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: Get.height * .2,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for an item...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().contains(searchValue);
                },
              )
            : null,
        onChanged: (value) {
          setState(() => this.value = value);
          widget.onChanged?.call(value);
        },
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
