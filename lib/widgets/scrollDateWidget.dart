import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/utils/utils.dart';

ScrollController? scrollController;

class ScrollDateWidget extends ConsumerStatefulWidget {
  const ScrollDateWidget({super.key});

  @override
  ConsumerState<ScrollDateWidget> createState() => _ScrollDateWidgetState();
}

class _ScrollDateWidgetState extends ConsumerState<ScrollDateWidget> {
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    // Scroll animato alla posizione di oggi (indice 60)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        var date = ref.read(selectedDateProvider);
        final today = DateTime.now();
        final startDate = today.add(const Duration(days: -60));
        final index = date.difference(startDate).inDays;
        double itemWidth = 70 + 16; // width + left+right padding
        scrollController!.animateTo(
          itemWidth * index,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutExpo,
        );
      });
    });
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder:
          (context, int) => SingleDateWidget(
            date: DateTime.now().add(Duration(days: -60 + int)),
          ),
      itemCount: 120,
    );
  }
}

class SingleDateWidget extends ConsumerWidget {
  SingleDateWidget({super.key, required this.date});
  final DateTime date;
  final List<String> giorniSettimana = const [
    'Lun',
    'Mar',
    'Mer',
    'Gio',
    'Ven',
    'Sab',
    'Dom',
  ];
  final List<String> mesi = const [
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

  Widget noSelectedDateWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
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
    );
  }

  Widget selectedDateWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              mesi[date.month - 1],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateProvider = ref.watch(selectedDateProvider);
    return GestureDetector(
      onTap: () {
        ref.read(selectedDateProvider.notifier).update((state) => date);
        // Calcola l'indice della data selezionata rispetto alla lista
        final today = DateTime.now();
        final startDate = today.add(const Duration(days: -60));
        final index = date.difference(startDate).inDays;
        double itemWidth = 70 + 16; // width + left+right padding
        scrollController!.animateTo(
          itemWidth * index,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutExpo,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            sameDate(date, dateProvider)
                ? selectedDateWidget()
                : noSelectedDateWidget(),
      ),
    );
  }
}
