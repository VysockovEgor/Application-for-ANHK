import 'package:anhk/pages/main_page/text.dart';
import 'package:anhk/pages/main_page/videoplayer.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import '../../design/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../templates/accordion.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior:
                Clip.none, // Позволяет белому контейнеру выходить за границы Stack
                children: [
                  // Синий прямоугольник во всю ширину
                  Container(
                    height: 200, // можно изменить под нужную высоту
                    width: double.infinity,
                    color: dark_blue,
                    child: Center(child: highlighted_logo),
                  ),
                  // Белый прямоугольник во всю ширину с округлыми углами
                  Positioned(
                    bottom: -8, // слегка выдвигаем вниз, чтобы не заходил слишком сильно на синий
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        color: background_color,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Заголовок "О нас"
              const Center(
                child: Text(
                  "О нас",
                  style: TextStyle(
                    fontFamily: "Europe",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    const Text(
                      about_us,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: "Europe",
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 200,
                      width: 350,
                      child: VideoPlayerBlock(
                        videoUrl:
                        'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _launchURL("https://museum.anhk.ru/"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20), // Увеличивает высоту кнопки
                        minimumSize: const Size(double.infinity, 60), // Растягивает кнопку по ширине и высоте
                      ),
                      child: const Text("Музей трудовой славы АО «АНХК»",
                        style: TextStyle(
                          fontFamily: "Europe",
                          fontSize: 14,
                        ),),
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
                        padding: const EdgeInsets.symmetric(vertical: 20), // Увеличивает высоту кнопки
                        minimumSize: const Size(double.infinity, 60), // Растягивает кнопку по ширине и высоте
                      ),
                      child: const Text("VK",
                        style: TextStyle(
                        fontFamily: "Europe",
                        fontSize: 14,
                      ),),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Наш адрес",
                      style: TextStyle(
                        fontFamily: "Europe",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Внутри Column, после текста "Наш адрес"
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge, // Обрезает содержимое по границам контейнера
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Фотография "map", автоматически растягивается по ширине контейнера
                          Image.asset(
                            'assets/images/map.png', // Укажи правильный путь к изображению
                            width: double.infinity,
                            fit: BoxFit.cover, // Заполняет контейнер, сохраняя пропорции
                          ),
                        Padding(
                          padding: const EdgeInsets.all(30.0), // Общий отступ для всей колонки
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
                                onTap: () => _launchURL("https://2gis.ru/angarsk/geo/1548748027095946"), // Замените URL на нужный
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

                    const SizedBox(height: 30,),
                    const Text(
                      "Пропускной режим",
                      style: TextStyle(
                        fontFamily: "Europe",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30,),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
