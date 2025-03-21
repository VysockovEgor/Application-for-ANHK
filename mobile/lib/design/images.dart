import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
final Image map = Image.asset("assets/images/map.png");
final Image clock = Image.asset("assets/images/clock_icon.png");
final Image maps_point = Image.asset("assets/images/maps_point.png");
final Image passport = Image.asset("assets/images/passport_icon.png");
final SvgPicture logo = SvgPicture.asset('assets/images/logo.svg');
final SvgPicture arrow_back = SvgPicture.asset('assets/images/arrow_back.svg');
final SvgPicture icon_yes = SvgPicture.asset(
    'assets/images/healthicons_yes.svg',
    height: 65,
    width: 65,
    fit: BoxFit.contain
);
final SvgPicture highlighted_logo = SvgPicture.asset(
  'assets/images/highlighted_logo.svg',
  height: 122,
  width: 122,
  fit: BoxFit.contain, // Здесь вы устанавливаете BoxFit
);

