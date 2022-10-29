import 'package:flutter/material.dart';
import 'package:recipez/Shared/model/app_color.dart';

const List<String> list = <String>['Oz', 'Kg', 'Und', 'Ml'];

class DropdownButtonQuantity extends StatefulWidget {
  const DropdownButtonQuantity({super.key});

  @override
  State<DropdownButtonQuantity> createState() => _DropdownButtonQuantityState();
}

class _DropdownButtonQuantityState extends State<DropdownButtonQuantity> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      underline: Container(
        height: 2,
        color: AppColor.lila_2_6be,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
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