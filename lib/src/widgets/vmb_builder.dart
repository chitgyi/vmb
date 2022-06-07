import 'package:flutter/widgets.dart';
import 'package:vmb/src/base_vmb.dart';

typedef VmbWidgetBuilder<T extends Vmb> = Widget Function(
  BuildContext context,
  T Vmb,
  Widget? child,
);

class VmbBuilder<T, B extends Vmb<T>> extends StatefulWidget {
  const VmbBuilder(
    this.Vmb, {
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);
  final B Vmb;
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
    widget.Vmb.onInit();
    value = widget.Vmb.value;
    widget.Vmb.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant VmbBuilder<T, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.Vmb.value != widget.Vmb.value) {
      oldWidget.Vmb.removeListener(_valueChanged);
      value = value;
      widget.Vmb.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.Vmb.onDispose();
    widget.Vmb.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.Vmb.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VmbProvider<B>(
      vmb: widget.Vmb,
      child: widget.builder(
        context,
        widget.Vmb,
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
