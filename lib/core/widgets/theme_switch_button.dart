import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/bloc/theme_bloc.dart';
import '../theme/bloc/theme_event.dart';
import '../theme/bloc/theme_state.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          tooltip: state.isDark ? 'Switch to light' : 'Switch to dark',
          icon: Icon(
            state.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () => context.read<ThemeBloc>().add(ThemeToggled()),
        );
      },
    );
  }
}
