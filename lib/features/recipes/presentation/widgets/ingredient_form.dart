import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipez/core/constants/app_color.dart';

const List<String> units = ['g', 'ml', 'und', 'cdta', 'cda', 'taza'];

class IngredientForm extends StatefulWidget {
  final Map<String, dynamic> ingredient;
  final Function(Map<String, dynamic>) onChanged;
  final VoidCallback onDelete;

  const IngredientForm({
    required this.ingredient,
    required this.onChanged,
    required this.onDelete,
    super.key,
  });

  @override
  State<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late String _dimension;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredient['name']);
    _valueController =
        TextEditingController(text: widget.ingredient['value'].toString());
    _dimension = widget.ingredient['dimension'];

    _nameController.addListener(_updateIngredient);
    _valueController.addListener(_updateIngredient);
  }

  void _updateIngredient() {
    widget.onChanged({
      'name': _nameController.text,
      'value': int.tryParse(_valueController.text) ?? 0,
      'dimension': _dimension,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.lila_2_6be),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.morado_2_347),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Cantidad',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.lila_2_6be),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.morado_2_347),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _dimension,
              decoration: InputDecoration(
                labelText: 'Unidad',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.lila_2_6be),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.morado_2_347),
                ),
              ),
              items: units
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _dimension = value;
                    _updateIngredient();
                  });
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
