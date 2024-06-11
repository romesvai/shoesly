import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';

import 'presentation/bloc/discover_cubit.dart';

@RoutePage()
class DiscoverWrapperPage extends StatelessWidget {
  const DiscoverWrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<DiscoverCubit>(
        create: (_) => getIt<DiscoverCubit>(),
        child: const AutoRouter(),
      );
}
