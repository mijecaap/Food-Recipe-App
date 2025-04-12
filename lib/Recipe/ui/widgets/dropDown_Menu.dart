import 'package:flutter/material.dart';
import 'package:recipez/Shared/model/app_color.dart';

const List<String> list = <String>['kg', 'gr', 'lt', 'unid'];

class DropdownButtonQuantity extends StatefulWidget {
  late String dropdownValue;
  late void Function(dynamic) pickValue;
  DropdownButtonQuantity({required this.dropdownValue, required this.pickValue, Key? key}) : super(key: key);

  @override
  State<DropdownButtonQuantity> createState() => _DropdownButtonQuantityState();
}

class _DropdownButtonQuantityState extends State<DropdownButtonQuantity> {
  @override
  Widget build(BuildContext context) {

    if(widget.dropdownValue == "") {
      widget.dropdownValue = list.first;
    }

    return DropdownButton<String>(
      value: widget.dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      underline: Container(
        height: 2,
        color: AppColor.lila_2_6be,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        widget.pickValue(value);
        /*setState(() {
          widget.dropdownValue = value!;
        });*/
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}