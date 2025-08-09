import 'package:flutter/material.dart';
import '../../../../templates/accordion.dart';
import '../../../../constants/text_constants.dart';

class AccessSection extends StatelessWidget {
  const AccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const Text(
              "Пропускной режим",
              style: TextStyle(
                fontFamily: "Europe",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
            CustomAccordion(
              title: note1[0],
              content: note1[1],
            ),
          ],
        ),
      ),
    );
  }
}
