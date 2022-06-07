import 'package:flutter/widgets.dart';
import 'package:vmb/src/base_vmb.dart';

typedef VmbWidgetBuilder<T extends Vmb> = Widget Function(
  BuildContext context,
  T vmb,
  Widget? child,
);

class VmbBuilder<T, B extends Vmb<T>> extends StatefulWidget {
  const VmbBuilder(
    this.vmb, {
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);
  final B vmb;
  final Widget? child;
  final VmbWidgetBuilder<B> builder;

  @override
  State<VmbBuilder> createState() => _VmbBuilderState<T, B>();
}

class _VmbBuilderState<T, B extends Vmb<T>> extends State<VmbBuilder<T, B>> {
  late T value;

  @override
  void initState() {
    super.initState();
    widget.vmb.onInit();
    value = widget.vmb.value;
    widget.vmb.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant VmbBuilder<T, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vmb.value != widget.vmb.value) {
      oldWidget.vmb.removeListener(_valueChanged);
      value = value;
      widget.vmb.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.vmb.onDispose();
    widget.vmb.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.vmb.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VmbProvider<B>(
      vmb: widget.vmb,
      child: widget.builder(
        context,
        widget.vmb,
        widget.child,
      ),
    );
  }
}

class VmbProvider<B extends Vmb> extends InheritedWidget {
  const VmbProvider({
    super.key,
    required super.child,
    required this.vmb,
  });
  final B vmb;

  static B? of<B extends Vmb>(
    BuildContext context,
  ) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<VmbProvider<B>>();
    return provider?.vmb;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget.child != child;
  }
}
