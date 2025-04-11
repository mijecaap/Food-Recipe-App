import 'package:flutter/material.dart';
import 'package:recipez/core/constants/app_color.dart';

const List<String> list = <String>['kg', 'gr', 'lt', 'unid'];

class DropdownButtonQuantity extends StatefulWidget {
  final String dropdownValue;
  final void Function(String?) pickValue;

  const DropdownButtonQuantity({
    required this.dropdownValue,
    required this.pickValue,
    super.key,
  });

  @override
  State<DropdownButtonQuantity> createState() => _DropdownButtonQuantityState();
}

class _DropdownButtonQuantityState extends State<DropdownButtonQuantity> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue =
        widget.dropdownValue.isEmpty ? list.first : widget.dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentValue,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      underline: Container(
        height: 2,
        color: AppColor.lila_2_6be,
      ),
      onChanged: (String? value) {
        setState(() {
          currentValue = value ?? list.first;
        });
        widget.pickValue(value);
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
