import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_data_fetching_loader.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/presentation/screens/discover_screen.dart';
import 'package:shoesly_ps/src/features/reviews/presentation/bloc/review_cubit.dart';
import 'package:shoesly_ps/src/features/reviews/presentation/widgets/review_widget.dart';

@RoutePage()
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.shoe,
  });

  final ShoeDataModel shoe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewCubit>(
      create: (_) => getIt<ReviewCubit>(param1: shoe),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(
                'Review (${shoe.totalReviews})',
                style: AppTextTheme.titleMedium,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.w,
                  ),
                  child: Row(
                    children: [
                      AssetsHelper.svgStarIcon.svg(),
                      Gap(5.h),
                      Text(
                        shoe.averageRating?.toStringAsFixed(1) ?? '0.0',
                        style: AppTextTheme.displaySmall.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                final starsData = state.stars;
                return Column(
                  children: [
                    Gap(20.h),
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.only(left: 30.w),
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            TappableSubheadingWidget(
                          selectableData: starsData[index],
                          onTap: () => context
                              .read<ReviewCubit>()
                              .selectStarFilter(starsData[index]),
                        ),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => Gap(16.w),
                        itemCount: starsData.length,
                      ),
                    ),
                    Gap(30.h),
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        if (state.reviews == null) {
                          return const Expanded(
                            child: CustomDataFetchingLoader(),
                          );
                        }
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                            ),
                            child: ReviewWidget.reviewsList(
                              reviews: state.reviews!,
                              showPaginationLoading: state.reviewLoadingState ==
                                      const ReviewLoadingState
                                          .paginationLoading() &&
                                  state.hasMoreDocuments,
                              onPaginate:
                                  context.read<ReviewCubit>().fetchAnotherPage,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
