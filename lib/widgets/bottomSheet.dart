import 'package:flutter/material.dart';

class BottomSheetCategory extends StatelessWidget {
  const BottomSheetCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {},
      ),
    );
  }
}
