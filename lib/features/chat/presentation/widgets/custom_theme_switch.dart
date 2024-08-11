import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/theme_cubit.dart';

class CustomAdvanceSwitch extends StatefulWidget {
  final double radius;
  final double thumbRadius;
  final Widget? activeChild;
  final Widget? inactiveChild;
  const CustomAdvanceSwitch(
      {super.key,
      this.radius = 40,
      this.thumbRadius = 100,
      this.activeChild,
      this.inactiveChild});

  @override
  State<CustomAdvanceSwitch> createState() => _CustomAdvanceSwitchState();
}

class _CustomAdvanceSwitchState extends State<CustomAdvanceSwitch> {
  final _controller00 = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return AdvancedSwitch(
      activeColor: Colors.black,
      inactiveColor: Theme.of(context).primaryColor,
      activeChild: widget.activeChild ?? const Text('Dark'),
      inactiveChild: widget.inactiveChild ?? const Text('Light'),
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      width: 80,
      height: 36,
      thumb: Container(
        margin: const EdgeInsets.all(5),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.thumbRadius)),
      ),
      controller: _controller00,
      onChanged: (value) {
        BlocProvider.of<ThemeCubit>(context).toggleTheme(value);
      },
    );
  }
}
