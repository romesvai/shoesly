import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/number_extensions.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/themes/typography/app_text_theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_data_fetching_loader.dart';
import 'package:shoesly_ps/src/core/widgets/custom_rounded_container.dart';
import 'package:shoesly_ps/src/core/widgets/custom_shimmer_widget.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';

@RoutePage()
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverCubit>(
      create: (_) => getIt<DiscoverCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Gap(50.h),
                const DiscoverHeadingWidget(),
                Gap(24.h),
                BlocSelector<DiscoverCubit, DiscoverState, List<BrandState>?>(
                  selector: (state) => state.brands,
                  builder: (context, brands) {
                    if (brands == null) {
                      return const SizedBox();
                    }
                    return Container(
                      height: 30.h,
                      padding: EdgeInsets.only(left: 30.w),
                      child: ListView.separated(
                        itemBuilder: (context, index) => BrandWidget(
                          brand: brands[index],
                          onTap: () => context
                              .read<DiscoverCubit>()
                              .selectBrand(brands[index]),
                        ),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => Gap(16.w),
                        itemCount: brands.length,
                      ),
                    );
                  },
                ),
                Gap(10.h),
                Expanded(
                  child: BlocBuilder<DiscoverCubit, DiscoverState>(
                    builder: (context, state) {
                      if (state.shoes == null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: CustomShimmerWidget(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 30.h,
                                crossAxisSpacing: 15.w,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, _) {
                                return CustomRoundedContainer(
                                  height: 150.r,
                                  width: 150.r,
                                  backgroundColor: AppColors.greyContainer,
                                  borderRadius: 20.circularBorderRadius,
                                );
                              },
                              itemCount: 6,
                            ),
                          ),
                        );
                      }
                      return ShoesGridWidget(
                        shoes: state.shoes!,
                        shoeImage: state.shoeImages ?? <String, List<String>>{},
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShoesGridWidget extends StatefulWidget {
  const ShoesGridWidget({
    super.key,
    required this.shoes,
    required this.shoeImage,
  });

  final List<ShoeDataModel> shoes;
  final Map<String, List<String>> shoeImage;

  @override
  State<ShoesGridWidget> createState() => _ShoesGridWidgetState();
}

class _ShoesGridWidgetState extends State<ShoesGridWidget> {
  final shoeGridScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initScrollListener();
  }

  void _initScrollListener() {
    shoeGridScrollController.addListener(() {
      if (shoeGridScrollController.position.maxScrollExtent ==
              shoeGridScrollController.position.pixels &&
          (context.read<DiscoverCubit>().state.hasMoreDocuments)) {
        if (context.read<DiscoverCubit>().state.discoverLoadingState !=
            const DiscoverLoadingState.paginationLoading()) {
          context.read<DiscoverCubit>().fetchAnotherPage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: GridView.builder(
        controller: shoeGridScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 1 / 1.5,
        ),
        itemCount: widget.shoes.length + 1,
        // shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == widget.shoes.length) {
            if (context.watch<DiscoverCubit>().state.discoverLoadingState ==
                    const DiscoverLoadingState.paginationLoading() &&
                (context.read<DiscoverCubit>().state.hasMoreDocuments)) {
              return const CustomDataFetchingLoader(
                size: 20,
              );
            } else {
              return const SizedBox();
            }
          } else {
            return Column(
              children: <Widget>[
                Stack(
                  children: [
                    CustomRoundedContainer(
                      height: 170.r,
                      width: 170.r,
                      backgroundColor: AppColors.greyContainer,
                      borderRadius: 20.circularBorderRadius,
                    ),
                    BlocBuilder<DiscoverCubit, DiscoverState>(
                      builder: (context, state) {
                        return CustomRoundedContainer(
                          height: 170.r,
                          width: 170.r,
                          borderRadius: 20.circularBorderRadius,
                          child: ClipRRect(
                            borderRadius: 20.circularBorderRadius,
                            child: CachedNetworkImage(
                              imageUrl: widget
                                      .shoeImage[widget.shoes[index].shoeId]
                                      ?.first ??
                                  '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 23.h,
                      left: 15.w,
                      child: getBrandIcon(
                        widget.shoes[index].brand,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Gap(10.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.shoes[index].name,
                        style: AppTextTheme.bodySmall
                            .copyWith(color: AppColors.title),
                      ),
                    ),
                    Gap(8.h),
                    Row(
                      children: <Widget>[
                        AssetsHelper.svgStarIcon.svg(),
                        Gap(5.w),
                        Text(
                          widget.shoes[index].averageRating.toString(),
                          style: AppTextTheme.displaySmall.copyWith(
                            fontSize: 11,
                          ),
                        ),
                        Gap(5.w),
                        Text(
                          '(${widget.shoes[index].totalReviews} Reviews)',
                          style: AppTextTheme.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        )
                      ],
                    ),
                    Gap(5.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '\$${widget.shoes[index].price}',
                        style: AppTextTheme.displaySmall.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  SvgPicture getBrandIcon(String brand) {
    switch (brand) {
      case jordan:
        return AssetsHelper.svgJordanIcon.svg();
      case adidas:
        return AssetsHelper.svgAdidasIcon.svg();
      case nike:
        return AssetsHelper.svgNikeLogo.svg();
      default:
        return AssetsHelper.svgNikeLogo.svg();
    }
  }
}

class BrandWidget extends StatelessWidget {
  const BrandWidget({
    super.key,
    required this.brand,
    required this.onTap,
  });

  final BrandState brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          brand.brandName,
          style: AppTextTheme.displaySmall.copyWith(
            color: brand.isSelected ? AppColors.textBlack : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class DiscoverHeadingWidget extends StatelessWidget {
  const DiscoverHeadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            context.l10n.discover,
            style: AppTextTheme.displayMedium,
          ),
          IconButton(
            onPressed: () {},
            icon: AssetsHelper.svgCartIcon.svg(),
          ),
        ],
      ),
    );
  }
}
