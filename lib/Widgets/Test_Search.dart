import 'package:flutter/material.dart';

class TextFieldSearch extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final VoidCallback callBackClear, callBackPrefix, callBackSearch;
  final isPrefixIconVisible;
  final String hintText;

  TextFieldSearch(
      {required this.textEditingController,
      required this.onChanged,
      required this.callBackClear,
      this.isPrefixIconVisible = false,
      required this.callBackSearch,
      required this.callBackPrefix,
      this.hintText = 'Search For Book More Test'});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: EdgeInsets.all(10),
        child: TextField(
            controller: textEditingController,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                suffixIcon: isPrefixIconVisible
                    ? IconButton(
                        icon:
                            Icon(Icons.search, size: 20, color: Colors.indigo),
                        onPressed: callBackPrefix)
                    : null,
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.elliptical(10, 10)),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.elliptical(10, 10)),
                    borderSide: BorderSide(color: Colors.white)),
                filled: true,
                hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    textBaseline: TextBaseline.alphabetic),
                hintText: hintText,
                fillColor: Colors.grey.withOpacity(0.1))));
  }
}
