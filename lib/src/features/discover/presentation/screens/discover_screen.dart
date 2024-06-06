import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';

@RoutePage()
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverCubit>(
      create: (_) => getIt<DiscoverCubit>()..addShoes(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: BlocBuilder<DiscoverCubit, DiscoverState>(
              builder: (context, state) {
            return Center(
              child: TextButton(
                child: const Text('Hello'),
                onPressed: () {
                  context.read<DiscoverCubit>().addShoes();
                },
              ),
            );
          }),
        );
      }),
    );
  }
}
