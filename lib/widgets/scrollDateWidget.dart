import 'package:flutter/material.dart';

class Scrolldatewidget extends StatelessWidget {
  const Scrolldatewidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,

      itemBuilder:
          (context, int) => SingleDateWidget(
            date: DateTime.now().add(Duration(days: -60 + int)),
          ),
      itemCount: 120,
    );
  }
}

class SingleDateWidget extends StatelessWidget {
  SingleDateWidget({super.key, required this.date});
  DateTime date;
  List<String> giorniSettimana = [
    'Lun',
    'Mar',
    'Mer',
    'Gio',
    'Ven',
    'Sab',
    'Dom',
  ];
  List<String> mesi = [
    'Gen',
    'Feb',
    'Mar',
    'Apr',
    'Mag',
    'Giu',
    'Lug',
    'Ago',
    'Set',
    'Ott',
    'Nov',
    'Dic',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.withOpacity(0.1),
        ),

        width: 70,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                giorniSettimana[date.weekday - 1],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                '${date.day}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                mesi[date.month - 1],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
