import 'package:flutter_riverpod/flutter_riverpod.dart';

class BounceButtonNotifier extends StateNotifier<bool> {
  BounceButtonNotifier() : super(false);

  void toggleBounce() {
    state = !state;
  }
}
