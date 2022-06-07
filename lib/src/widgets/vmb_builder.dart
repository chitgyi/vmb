import 'package:flutter/widgets.dart';
import 'package:vmb/src/base_vmb.dart';

typedef VmbWidgetBuilder<T extends BaseVmb> = Widget Function(
  BuildContext context,
  T baseVmb,
  Widget? child,
);

class VmbBuilder<T, B extends BaseVmb<T>> extends StatefulWidget {
  const VmbBuilder(
    this.baseVmb, {
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);
  final B baseVmb;
  final Widget? child;
  final VmbWidgetBuilder<B> builder;

  @override
  State<VmbBuilder> createState() => _VmbBuilderState<T, B>();
}

class _VmbBuilderState<T, B extends BaseVmb<T>>
    extends State<VmbBuilder<T, B>> {
  late T value;

  @override
  void initState() {
    super.initState();
    widget.baseVmb.onInit();
    value = widget.baseVmb.value;
    widget.baseVmb.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant VmbBuilder<T, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseVmb.value != widget.baseVmb.value) {
      oldWidget.baseVmb.removeListener(_valueChanged);
      value = value;
      widget.baseVmb.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.baseVmb.onDispose();
    widget.baseVmb.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.baseVmb.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VmbProvider<B>(
      baseVmb: widget.baseVmb,
      child: widget.builder(
        context,
        widget.baseVmb,
        widget.child,
      ),
    );
  }
}

class VmbProvider<B extends BaseVmb> extends InheritedWidget {
  const VmbProvider({
    super.key,
    required super.child,
    required this.baseVmb,
  });
  final B baseVmb;

  static B? of<B extends BaseVmb>(
    BuildContext context,
  ) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<VmbProvider<B>>();
    return provider?.baseVmb;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget.child != child;
  }
}
