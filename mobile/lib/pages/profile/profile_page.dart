import 'package:anhk/design/dimensions.dart';
import 'package:anhk/pages/profile/documents.dart';
import 'package:anhk/pages/profile/settings/settings.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import 'package:anhk/pages/report/report_page.dart';
import 'package:anhk/pages/registrate/registrate_page.dart';
import 'package:anhk/pages/profile/achievements/achievments_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String name = "Иван Иванов";
  static const String status = "студент";
  static const String days = "115";

    void _navigate(BuildContext context, int settings) {
      Widget page;

      if (settings == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Settings(),
          ),
        );
      } else if (settings == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Documents(),
          ),
        );
      } else if (settings == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Report(),
          ),
        );
      } else if (settings == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Registrate(),
          ),
        );
      } else if (settings == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AchievmentsPage(),
          ),
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Верхняя часть с синим фоном и логотипом
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    color: dark_blue,
                  ),
                  Positioned(
                    bottom: -8,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Row(
                        children: [
                          // Фотография в круглой рамке
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage("assets/images/user.png"),
                          ),
                          SizedBox(width: 16.0),
                          // Текст, занимающий оставшееся пространство
                          Expanded(
                            child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: big,
                                          fontFamily: "Europe",
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      status,
                                      style: TextStyle(
                                          fontFamily: "Europe",
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  days + " дней",
                                  style: TextStyle(
                                    fontSize: big+10,
                                    fontFamily: "Europe",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "до окончания практики",
                                  style: TextStyle(
                                    fontFamily: "Europe",
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ),
                        const SizedBox(width: 20,),

                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                "2/3",
                                style: TextStyle(
                                  fontSize: big+8,
                                  fontFamily: "Europe",
                                ),
                              ),
                              Text(
                                "заданий",
                                style: TextStyle(
                                  fontFamily: "Europe",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),


                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // скругленные углы
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Заголовочная часть
                          InkWell(
                            onTap: () {
                              _navigate(context, 0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Сменить пароль",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Europe",
                                      ),
                                    ),
                                  ),
                                  // Желтый/серый круг с плюсом/минусом
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      color: yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Заголовок
                                ],
                              ),
                            ),
                          ),
                          // Подзаголовочный текст, который появляется при нажатии
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // скругленные углы
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Заголовочная часть
                          InkWell(
                            onTap: () {
                              _navigate(context, 1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Необходимые документы",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Europe",
                                      ),
                                    ),
                                  ),
                                  // Желтый/серый круг с плюсом/минусом
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      color: yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Заголовок
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // скругленные углы
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Заголовочная часть
                          InkWell(
                            onTap: () {
                              _navigate(context, 2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Отчеты",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Europe",
                                      ),
                                    ),
                                  ),
                                  // Желтый/серый круг с плюсом/минусом
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      color: yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Заголовок
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // скругленные углы
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Заголовочная часть
                          InkWell(
                            onTap: () {
                              _navigate(context, 3);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Зарегестрировать пользователей",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Europe",
                                      ),
                                    ),
                                  ),
                                  // Желтый/серый круг с плюсом/минусом
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      color: yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Заголовок
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // скругленные углы
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Заголовочная часть
                          InkWell(
                            onTap: () {
                              _navigate(context, 4);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Достижения",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Europe",
                                      ),
                                    ),
                                  ),
                                  // Желтый/серый круг с плюсом/минусом
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      color: yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Заголовок
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
