// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Image map = Image.asset("assets/images/map.png");
final Image clock = Image.asset("assets/images/clock_icon.png");
final Image maps_point = Image.asset("assets/images/maps_point.png");
final Image passport = Image.asset("assets/images/passport_icon.png");
final Image attach = Image.asset("assets/images/attach.png");
final Image location = Image.asset("assets/images/Location.png");
final Image people = Image.asset("assets/images/People.png");
final Image mask_group = Image.asset("assets/images/Mask-group.png");
final Image gift = Image.asset("assets/images/gift.png");
final Image cup = Image.asset(
  "assets/images/cup.png",
  height: 40,
  width: 40,
  fit: BoxFit.contain,
);
final Image user = Image.asset(
  "assets/images/user.png",
  fit: BoxFit.cover,
);
final Image sunset_factory = Image.asset(
  "assets/images/sunset_factory.png",
  fit: BoxFit.cover,
);

// Level images
final Image beginner_level = Image.asset(
  "assets/images/beginner.png",
  fit: BoxFit.cover,
);
final Image advanced_level = Image.asset(
  "assets/images/advanced.png",
  fit: BoxFit.cover,
);
final Image pro_level = Image.asset(
  "assets/images/pro.png",
  fit: BoxFit.cover,
);

// Stats images
final Image medal = Image.asset(
  "assets/images/medal.png",
  width: 32,
  height: 32,
  fit: BoxFit.contain,
);
final Image time_clock = Image.asset(
  "assets/images/clock.png",
  width: 32,
  height: 32,
  fit: BoxFit.contain,
);

final SvgPicture logo = SvgPicture.asset('assets/images/logo.svg');
final SvgPicture arrow_back = SvgPicture.asset('assets/images/arrow_back.svg');
final SvgPicture icon_yes = SvgPicture.asset(
    'assets/images/healthicons_yes.svg',
    height: 65,
    width: 65,
    fit: BoxFit.contain);
final SvgPicture highlighted_logo = SvgPicture.asset(
  'assets/images/highlighted_logo.svg',
  height: 122,
  width: 122,
  fit: BoxFit.contain, // Здесь вы устанавливаете BoxFit
);
