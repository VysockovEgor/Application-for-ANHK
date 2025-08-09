import 'package:flutter/material.dart';
import '../../../../constants/text_constants.dart';
import '../../../../components/video_player.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "О нас",
              style: TextStyle(
                fontFamily: "Europe",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              about_us,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "Europe",
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 350,
              child: VideoPlayerBlock(
                videoUrl: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
