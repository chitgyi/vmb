import 'package:flutter/material.dart';
import 'package:vmb/vmb.dart';

class HomeVmb<T> extends BaseVmb<T> {
  HomeVmb(T value) : super(value);

  @override
  void onInit() {
    debugPrint('on init');
    super.onInit();
  }

  @override
  void onDispose() {
    debugPrint('on dispose');
    super.onDispose();
  }
}
