import 'package:anhk/design/dimensions.dart';
import 'package:anhk/design/images.dart';
import 'package:anhk/pages/profile/settings/change_password_page.dart';
import 'package:anhk/pages/profile/settings/change_login_page.dart';
import 'package:anhk/pages/profile/settings/set_password_page.dart';
import 'package:anhk/pages/profile/settings/change_email_page.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import 'package:anhk/pages/achievements/achievements_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const String name = "Иван Иванов";
  static const String status = "студент";
  static const String days = "115";
  static const String routeName = 'profile';

  void _handleLogout(BuildContext context) {
    // TODO: Реализовать выход из аккаунта
    debugPrint('Logging out...');
  }

  void _navigate(BuildContext context, int settings) {
    switch (settings) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChangePasswordPage(),
            settings: const RouteSettings(name: 'change_password'),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChangeLoginPage(),
            settings: const RouteSettings(name: 'change_login'),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SetPasswordPage(),
            settings: const RouteSettings(name: 'set_password'),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChangeEmailPage(),
            settings: const RouteSettings(name: 'change_email'),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/images/user.png"),
                          ),
                          const SizedBox(width: 16.0),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: big,
                                    fontFamily: "Europe",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontFamily: "Europe",
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _handleLogout(context),
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$days дней",
                                  style: TextStyle(
                                    fontSize: big + 10,
                                    fontFamily: "Europe",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "до окончания практики",
                                  style: TextStyle(
                                    fontFamily: "Europe",
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AchievementsPage(),
                                  settings:
                                      const RouteSettings(name: 'achievements'),
                                ),
                              );
                            },
                            child: Center(
                              child: cup,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      "Сменить пароль",
                      0,
                    ),
                    _buildSettingItem(
                      context,
                      "Сменить логин",
                      1,
                    ),
                    _buildSettingItem(
                      context,
                      "Установить пароль",
                      2,
                    ),
                    _buildSettingItem(
                      context,
                      "Сменить электронную почту",
                      3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, String title, int settingIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigate(context, settingIndex),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Europe",
                  ),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
