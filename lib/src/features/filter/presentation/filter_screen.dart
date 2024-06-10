import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';
import 'package:shoesly_ps/src/core/constants/shoesly_constants.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/number_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/string_extensions.dart';
import 'package:shoesly_ps/src/core/helper/brand_icon_helper.dart';
import 'package:shoesly_ps/src/core/helper/color_helper.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/app_button.dart';
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
      body: BlocConsumer<DiscoverCubit, DiscoverState>(
        listener: (context, state) {
          if (state.filterApplied) {
            context.maybePop();
            context.read<DiscoverCubit>().resetFilterAppliedFlag();
          }
        },
        listenWhen: (previous, current) =>
            previous.filterApplied != current.filterApplied,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(30.h),
                        Text(
                          l10n.brands,
                          style: AppTextTheme.titleMedium,
                        ),
                        Gap(20.h),
                        const FilterBrandsWidget(),
                        Gap(30.h),
                        Text(
                          l10n.priceRange,
                          style: AppTextTheme.titleMedium,
                        ),
                        Gap(28.h),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '\$${state.priceRange.start.toInt()}  -  \$${state.priceRange.end.toInt()}',
                            style: AppTextTheme.displaySmall.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Gap(8.h),
                        CustomRangeSlideThemeWidget(
                          slider: RangeSlider(
                            values: state.priceRange,
                            min: minPriceValue,
                            max: maxPriceValue,
                            onChanged: context
                                .read<DiscoverCubit>()
                                .onPriceRangeChanged,
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
                        ),
                        Gap(30.h),
                        Text(
                          l10n.sortBy,
                          style: AppTextTheme.titleMedium,
                        ),
                        Gap(20.h),
                        BlocSelector<DiscoverCubit, DiscoverState, String?>(
                          selector: (state) => state.sortBy,
                          builder: (context, selectedSortMethod) {
                            return HorizontalSelectableChipsWidget(
                              selectedData: selectedSortMethod,
                              data: sortBy,
                              onSelect: (sortByMethod) {
                                context
                                    .read<DiscoverCubit>()
                                    .setSortBy(sortBy: sortByMethod);
                              },
                            );
                          },
                        ),
                        Gap(30.h),
                        Text(
                          l10n.gender,
                          style: AppTextTheme.titleMedium,
                        ),
                        Gap(20.h),
                        BlocSelector<DiscoverCubit, DiscoverState, String?>(
                          selector: (state) => state.gender,
                          builder: (context, selectedGender) {
                            return HorizontalSelectableChipsWidget(
                              selectedData: selectedGender,
                              data: genderFilters,
                              onSelect: (selectedGender) {
                                context.read<DiscoverCubit>().setGender(
                                      gender: selectedGender,
                                    );
                              },
                            );
                          },
                        ),
                        Gap(30.h),
                        Text(
                          l10n.color,
                          style: AppTextTheme.titleMedium,
                        ),
                        Gap(20.h),
                        BlocSelector<DiscoverCubit, DiscoverState, String?>(
                          selector: (state) => state.color,
                          builder: (context, selectedColor) {
                            return HorizontalSelectableChipsWidget(
                              selectedData: selectedColor,
                              data: colorFilters,
                              onSelect: (selectedColor) {
                                context.read<DiscoverCubit>().setColor(
                                      color: selectedColor,
                                    );
                              },
                              isForColor: true,
                            );
                          },
                        ),
                        Gap(40.h),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 90.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<DiscoverCubit, DiscoverState>(
                      builder: (context, state) {
                        return AppButton.white(
                          label: l10n
                              .reset(
                                context
                                    .read<DiscoverCubit>()
                                    .getNumberOfAppliedFilters(),
                              )
                              .toUpperCase(),
                          onPressed: context.read<DiscoverCubit>().resetFilters,
                          fullWidth: false,
                          textStyle: AppTextTheme.displaySmall.copyWith(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        );
                      },
                    ),
                    AppButton.black(
                      label: l10n.apply.toUpperCase(),
                      onPressed: context.read<DiscoverCubit>().applyFilter,
                      fullWidth: false,
                      textStyle: AppTextTheme.displaySmall.copyWith(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HorizontalSelectableChipsWidget extends StatelessWidget {
  const HorizontalSelectableChipsWidget({
    super.key,
    required this.selectedData,
    required this.data,
    required this.onSelect,
    this.isForColor = false,
  });

  final String? selectedData;
  final List<String> data;
  final Function(String sortByMethod) onSelect;
  final bool isForColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isCurrentItemSelected = selectedData == data[index];
          return GestureDetector(
            onTap: () {
              onSelect(
                data[index],
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 7.h,
              ),
              decoration: BoxDecoration(
                borderRadius: 100.circularBorderRadius,
                color: isCurrentItemSelected && !isForColor
                    ? AppColors.textBlack
                    : AppColors.white,
                border: Border.all(
                  color: isCurrentItemSelected
                      ? AppColors.textBlack
                      : AppColors.lightGrey,
                ),
              ),
              child: Row(
                children: [
                  if (isForColor) ...[
                    CustomColorContainer(
                      size: 20.r,
                      color: ColorHelper.getColorFromString(data[index]),
                      isSelected: false,
                    ),
                    Gap(
                      5.h,
                    ),
                  ],
                  Text(
                    data[index].capitalize(),
                    style: AppTextTheme.titleMedium.copyWith(
                      color: isCurrentItemSelected && !isForColor
                          ? AppColors.white
                          : AppColors.textBlack,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, index) => Gap(21.w),
        itemCount: data.length,
      ),
    );
  }
}

class FilterBrandsWidget extends StatelessWidget {
  const FilterBrandsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoverCubit, DiscoverState,
        List<SelectableDataState>?>(
      selector: (state) => state.brands,
      builder: (context, brands) {
        return SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final brand = brands?[index];
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
                        if (brand?.isSelected ?? false)
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
            itemCount: brands?.length ?? 0,
          ),
        );
      },
    );
  }
}
