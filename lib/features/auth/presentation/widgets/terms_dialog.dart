import 'package:flutter/material.dart';
import 'package:recipez/core/constants/app_color.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Terms and Conditions'),
            content: const SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Text(
                  'Lorem ipsum dolor sit amet...',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showTermsDialog(context),
      child: Text(
        "Términos y Condiciones",
        style: TextStyle(fontSize: 12.0, color: AppColor.morado_3_53c),
      ),
    );
  }
}
