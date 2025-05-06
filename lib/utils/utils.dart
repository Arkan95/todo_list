import 'dart:ui';

import 'package:intl/intl.dart';

DateFormat formatterSql = DateFormat('yyyy-MM-dd');

DateFormat formatterDate = DateFormat('dd/mm/yyyy');

DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // Aggiunge l'opacità massima (FF) se assente
  }
  return Color(int.parse(hex, radix: 16));
}

String colorToHex(Color color, {bool leadingHashSign = true}) {
  return '${leadingHashSign ? '#' : ''}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';
}
