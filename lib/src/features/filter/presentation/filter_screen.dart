import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';
import 'package:shoesly_ps/src/core/constants/shoesly_constants.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';
import 'package:shoesly_ps/src/core/helper/brand_icon_helper.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_slider_theme_widget.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';
import 'package:shoesly_ps/src/features/product_detail/presentation/widgets/custom_color_container.dart';

@RoutePage()
class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          l10n.filter,
        ),
      ),
      body: BlocBuilder<DiscoverCubit, DiscoverState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30.h),
                Text(
                  l10n.brands,
                  style: AppTextTheme.titleMedium,
                ),
                Gap(20.h),
                SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final brand = state.brands?[index];
                        if (brand?.displayName == allBrands.displayName) {
                          return const SizedBox();
                        }
                        return GestureDetector(
                          onTap: () {
                            context.read<DiscoverCubit>().selectBrand(brand!);
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      height: 50.r,
                                      width: 50.r,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.lightGrey,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: BrandIconHelper.getBrandIcon(
                                          brand?.displayName ?? '',
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (state.brands?[index].isSelected ?? false)
                                    Positioned(
                                      bottom: 4.h,
                                      right: 0,
                                      child: CustomColorContainer(
                                        size: 16.r,
                                        color: Colors.black,
                                        isSelected: true,
                                      ),
                                    ),
                                ],
                              ),
                              Gap(10.h),
                              Text(
                                brand?.displayName ?? '',
                                style: AppTextTheme.displaySmall.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, index) =>
                          index == 0 ? 0.horizontalSpace : Gap(21.w),
                      itemCount: state.brands?.length ?? 0),
                ),
                Gap(30.h),
                Text(
                  l10n.priceRange,
                  style: AppTextTheme.titleMedium,
                ),
                Gap(36.h),
                CustomRangeSlideThemeWidget(
                  slider: RangeSlider(
                    values: context.watch<DiscoverCubit>().state.priceRange,
                    min: minPriceValue,
                    max: maxPriceValue,
                    onChanged:
                        context.read<DiscoverCubit>().onPriceRangeChanged,
                    activeColor: AppColors.textBlack,
                    inactiveColor: AppColors.lightGrey,
                  ),
                ),
                Gap(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.priceText(minPriceValue.toInt()),
                      style: AppTextTheme.displaySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      l10n.priceText(maxPriceValue.toInt()),
                      style: AppTextTheme.displaySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
