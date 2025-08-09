import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import 'top_menu.dart';

class BasePageTemplate extends ConsumerWidget {
  final Widget child;
  final bool showBackButton;
  final bool showLogo;

  const BasePageTemplate({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFF6F7FB),
        child: Stack(
          children: [
            // Header section with dark background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 330,
              child: Container(
                color: const Color(0xFF0D1720),
                child: TopMenu(
                  userName: user.name,
                  userLevel: user.level,
                  points: user.points,
                  showBackButton: showBackButton,
                  showLogo: showLogo,
                ),
              ),
            ),
            // Main content area
            Positioned(
              top: 124,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFDFDFE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
