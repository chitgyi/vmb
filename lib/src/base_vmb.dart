import 'package:flutter/foundation.dart';

abstract class BaseVmb<T> extends ValueNotifier<T> {
  BaseVmb(T value) : super(value);

  void onInit() {}

  void onDispose() {}
}
