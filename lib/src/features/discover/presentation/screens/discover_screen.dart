import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';

@RoutePage()
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverCubit>(
      create: (_) => getIt<DiscoverCubit>(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Gap(30.h),
              Row(
                children: <Widget>[
                  Text(
                    'Discover',
                    style:   
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
