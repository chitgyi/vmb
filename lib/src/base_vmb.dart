import 'package:flutter/foundation.dart';

abstract class Vmb<T> extends ValueNotifier<T> {
  Vmb(T value) : super(value);

  void onInit() {}

  void onDispose() {}
}
