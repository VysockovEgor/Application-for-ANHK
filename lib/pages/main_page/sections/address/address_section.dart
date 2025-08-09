import 'package:flutter/material.dart';
import '../../../../design/images.dart';
import '../../../../constants/text_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

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
            const Text(
              "Наш адрес",
              style: TextStyle(
                fontFamily: "Europe",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  map,
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Иркутская область, г.Ангарск, Промзона АНХК, 413а",
                          style: TextStyle(
                            fontFamily: "Europe",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          locate,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: "Europe",
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchURL(
                              "https://2gis.ru/angarsk/geo/1548748027095946"),
                          child: const Text(
                            "Открыть в 2GIS",
                            style: TextStyle(
                              fontFamily: "Europe",
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
