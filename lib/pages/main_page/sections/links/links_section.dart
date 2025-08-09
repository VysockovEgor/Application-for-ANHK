import 'package:flutter/material.dart';
import '../../../../design/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksSection extends StatelessWidget {
  const LinksSection({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL("https://museum.anhk.ru/"),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text(
                "Музей трудовой славы АО «АНХК»",
                style: TextStyle(
                  fontFamily: "Europe",
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _launchURL("https://vk.com/anhk_rosneft"),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text(
                "VK",
                style: TextStyle(
                  fontFamily: "Europe",
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
