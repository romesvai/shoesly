import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/extensions/number_extensions.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/app_button.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_ratings_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_rounded_container.dart';
import 'package:shoesly_ps/src/core/widgets/custom_shimmer_widget.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/product_detail/presentation/bloc/detail_cubit.dart';
import 'package:shoesly_ps/src/features/reviews/presentation/widgets/review_widget.dart';

@RoutePage()
class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.shoe,
  });

  final ShoeDataModel shoe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailCubit>(
      create: (_) => getIt<DetailCubit>(
        param1: shoe,
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: IconButton(
                    icon: AssetsHelper.svgCartIcon.svg(),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            body: BlocBuilder<DetailCubit, DetailState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Gap(16.h),
                              const DetailImageWidget(),
                              Gap(30.h),
                              Text(
                                shoe.name,
                                style: AppTextTheme.displaySmall,
                              ),
                              Gap(10.h),
                              ReviewAndRatingsWidget(shoe: shoe),
                              Gap(30.h),
                              SizeWidget(shoe: shoe),
                              Gap(30.h),
                              DescriptionWidget(shoe: shoe),
                              Gap(30.h),
                              Text(
                                'Review (${shoe.totalReviews})',
                                style: AppTextTheme.titleMedium,
                              ),
                              Gap(16.h),
                              if (state.reviews != null)
                                ReviewWidget(
                                  reviews: state.reviews!,
                                ),
                              Gap(30.h),
                              AppButton.white(
                                label: 'SEE ALL REVIEW',
                                onPressed: () {
                                  context.router.navigate(
                                    ReviewRoute(shoe: shoe),
                                  );
                                },
                                textStyle: AppTextTheme.displaySmall.copyWith(
                                  color: AppColors.textBlack,
                                  fontSize: 14,
                                ),
                              ),
                              Gap(36.h)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const DetailBottomContainer()
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

class DetailBottomContainer extends StatelessWidget {
  const DetailBottomContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCubit, DetailState>(
      builder: (context, state) {
        return Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Set the shadow color
                spreadRadius: 5, // Set the spread radius of the shadow
                blurRadius: 7, // Set the blur radius of the shadow
                offset: const Offset(0, -3), // Set the offset of the shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                Gap(21.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                        Gap(6.h),
                        Text(
                          '\$${state.shoe?.price}',
                          style: AppTextTheme.displaySmall,
                        ),
                      ],
                    ),
                    AppButton.black(
                      label: 'ADD TO CART',
                      onPressed: () {},
                      fullWidth: false,
                      height: 50.h,
                      textStyle: AppTextTheme.displaySmall.copyWith(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                    // Text('yo')
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.shoe,
  });

  final ShoeDataModel shoe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextTheme.titleMedium,
        ),
        Gap(12.h),
        Text(
          shoe.description,
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.sizeTextGrey,
          ),
        )
      ],
    );
  }
}

class SizeWidget extends StatelessWidget {
  const SizeWidget({
    super.key,
    required this.shoe,
  });

  final ShoeDataModel shoe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: AppTextTheme.titleMedium,
        ),
        Gap(10.h),
        SizedBox(
          height: 42.h,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => context.read<DetailCubit>().setSelectedSize(
                          shoe.availableSizes[index],
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              context.watch<DetailCubit>().state.selectedSize !=
                                      shoe.availableSizes[index]
                                  ? AppColors.greyContainer
                                  : AppColors.textBlack,
                        ),
                        color:
                            context.watch<DetailCubit>().state.selectedSize ==
                                    shoe.availableSizes[index]
                                ? AppColors.textBlack
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          shoe.availableSizes[index].toString(),
                          style: AppTextTheme.displaySmall.copyWith(
                            fontSize: 14,
                            color: context
                                        .watch<DetailCubit>()
                                        .state
                                        .selectedSize ==
                                    shoe.availableSizes[index]
                                ? AppColors.white
                                : AppColors.sizeTextGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (_, __) => Gap(15.w),
              itemCount: shoe.availableSizes.length),
        ),
      ],
    );
  }
}

class ReviewAndRatingsWidget extends StatelessWidget {
  const ReviewAndRatingsWidget({
    super.key,
    required this.shoe,
  });

  final ShoeDataModel shoe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomRatingsBar(ratingValue: shoe.averageRating ?? 0.0),
        Gap(8.w),
        Text(
          shoe.averageRating?.toStringAsFixed(1) ?? '0.0',
          style: AppTextTheme.displaySmall.copyWith(fontSize: 11),
        ),
        Gap(8.w),
        Text(
          '(${shoe.totalReviews} Reviews)',
          style: AppTextTheme.displaySmall.copyWith(
            fontSize: 11,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class DetailImageWidget extends StatelessWidget {
  const DetailImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CustomRoundedContainer(
            height: 315.r,
            width: double.infinity,
            borderRadius: 20.circularBorderRadius,
            child: ClipRRect(
              borderRadius: 20.circularBorderRadius,
              child: BlocBuilder<DetailCubit, DetailState>(
                builder: (context, state) {
                  if (state.shoeImages == null) {
                    return CustomShimmerWidget(
                      child: CustomRoundedContainer(
                        height: 315.r,
                        width: 315.r,
                        borderRadius: 20.circularBorderRadius,
                        backgroundColor: AppColors.greyContainer,
                      ),
                    );
                  }
                  return CachedNetworkImage(
                    imageUrl: state.shoeImages?[0] ?? '',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(left: 37.w, bottom: 26.h, child: const Text('hello'))
      ],
    );
  }
}