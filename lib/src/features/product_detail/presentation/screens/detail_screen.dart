import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/number_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/string_extensions.dart';
import 'package:shoesly_ps/src/core/helper/color_helper.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/app_button.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_ratings_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_rounded_container.dart';
import 'package:shoesly_ps/src/core/widgets/custom_shimmer_widget.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';
import 'package:shoesly_ps/src/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/product_detail/presentation/bloc/detail_cubit.dart';
import 'package:shoesly_ps/src/features/product_detail/presentation/widgets/custom_color_container.dart';
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
    final l10n = context.l10n;
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
                    onPressed: () {
                      context.router.navigate(
                        const CartRoute(),
                      );
                    },
                    icon: BlocSelector<CartCubit, CartState,
                        List<CartItemDataModel>?>(
                      selector: (state) => state.cartItems,
                      builder: (context, cartItems) {
                        return Stack(
                          children: [
                            AssetsHelper.svgCartIcon.svg(),
                            if (cartItems?.isNotEmpty == true)
                              Positioned(
                                bottom: 12.h,
                                right: 2.w,
                                child: CustomColorContainer(
                                  size: 8.r,
                                  color: AppColors.error,
                                  isSelected: false,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
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
                                l10n.reviewHeadingText(
                                    shoe.totalReviews.toString()),
                                style: AppTextTheme.titleMedium,
                              ),
                              Gap(16.h),
                              if (state.reviews != null)
                                ReviewWidget(
                                  reviews: state.reviews!,
                                ),
                              Gap(30.h),
                              AppButton.white(
                                label: l10n.seeAllReview.toUpperCase(),
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
    final l10n = context.l10n;
    return BlocConsumer<DetailCubit, DetailState>(
      listener: (context, state) {
        state.detailLoadingState.maybeWhen(
          orElse: () {},
          xception: (exception) {
            context.showSnackBar(
              Text(
                exception!.toLocalized(l10n),
                style: AppTextTheme.displayMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            );
          },
        );
      },
      listenWhen: (previous, current) =>
          previous.detailLoadingState != current.detailLoadingState,
      builder: (context, state) {
        return Container(
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
                          l10n.price.capitalize(),
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                        Gap(6.h),
                        Text(
                          l10n.priceText(state.shoe?.price.toString() ?? ''),
                          style: AppTextTheme.displaySmall,
                        ),
                      ],
                    ),
                    AppButton.black(
                      label: l10n.addToCart.toUpperCase(),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: AppColors.white,
                          context: context,
                          builder: (_) {
                            return BlocProvider<DetailCubit>.value(
                              value: context.read<DetailCubit>(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    BlocBuilder<DetailCubit, DetailState>(
                                      builder: (context, state) {
                                        if (state.detailLoadingState ==
                                            const DetailLoadingState
                                                .addToCartSuccess()) {
                                          return Column(
                                            children: [
                                              Gap(30.h),
                                              AssetsHelper.svgTickCircleIcon
                                                  .svg(),
                                              Gap(20.h),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  l10n.addedToCart,
                                                  style: AppTextTheme
                                                      .titleMedium
                                                      .copyWith(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                              Gap(10.h),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  l10n.itemAdded(
                                                      state.quantity),
                                                  style:
                                                      AppTextTheme.bodyMedium,
                                                ),
                                              ),
                                              Gap(20.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  AppButton.white(
                                                    label: l10n.backExplore
                                                        .toUpperCase(),
                                                    onPressed: () {
                                                      context.maybePop();
                                                    },
                                                    fullWidth: false,
                                                    height: 50.h,
                                                    textStyle: AppTextTheme
                                                        .displaySmall
                                                        .copyWith(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textBlack,
                                                    ),
                                                  ),
                                                  AppButton.black(
                                                    label: l10n.toCart
                                                        .toUpperCase(),
                                                    onPressed: () {
                                                      context.router.navigate(
                                                        const CartRoute(),
                                                      );
                                                    },
                                                    fullWidth: false,
                                                    height: 50.h,
                                                    textStyle: AppTextTheme
                                                        .displaySmall
                                                        .copyWith(
                                                      fontSize: 14,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(30.h),
                                            ],
                                          );
                                        } else {
                                          return const AddToCartWidget();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).then((_) {
                          context.read<DetailCubit>().resetAddToCartSuccess();
                        });
                      },
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

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Gap(10.h),
        Align(
          alignment: Alignment.center,
          child: AssetsHelper.svgModalGreyIcon.svg(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.addToCart,
              style: AppTextTheme.displaySmall,
            ),
            IconButton(
              onPressed: () {
                context.maybePop();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        Gap(30.h),
        Text(
          l10n.quantity,
          style: AppTextTheme.displaySmall.copyWith(
            fontSize: 14,
          ),
        ),
        Gap(8.h),
        BlocSelector<DetailCubit, DetailState, int>(
          selector: (state) => state.quantity,
          builder: (context, quantity) {
            return PriceQuantityRowWidget(
              quantity: quantity,
              onMinusButtonClick: context.read<DetailCubit>().decreaseQuantity,
              onPlusButtonClick: context.read<DetailCubit>().increaseQuantity,
            );
          },
        ),
        Gap(20.h),
        Padding(
          padding: EdgeInsets.only(
            right: 16.w,
          ),
          child: const Divider(
            color: AppColors.textBlack,
          ),
        ),
        Gap(30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.price.capitalize(),
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                Gap(6.h),
                BlocSelector<DetailCubit, DetailState, int>(
                  selector: (state) => state.quantity,
                  builder: (context, quantity) {
                    return Text(
                      l10n.priceText(
                          context.read<DetailCubit>().state.shoe!.price *
                              quantity),
                      style: AppTextTheme.displaySmall,
                    );
                  },
                ),
              ],
            ),
            AppButton.black(
              label: l10n.addToCart.toUpperCase(),
              onPressed: context.read<DetailCubit>().addItemToCart,
              fullWidth: false,
              height: 50.h,
              textStyle: AppTextTheme.displaySmall.copyWith(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        Gap(20.h)
      ],
    );
  }
}

class PriceQuantityRowWidget extends StatelessWidget {
  const PriceQuantityRowWidget(
      {super.key,
      required this.quantity,
      required this.onMinusButtonClick,
      required this.onPlusButtonClick});

  final int quantity;
  final VoidCallback onMinusButtonClick;
  final VoidCallback onPlusButtonClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          quantity.toString(),
          style: AppTextTheme.bodyMedium,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onMinusButtonClick,
                child: AssetsHelper.svgMinusCircleIcon.svg(
                  colorFilter: quantity != 1
                      ? const ColorFilter.mode(
                          AppColors.textBlack,
                          BlendMode.srcIn,
                        )
                      : null,
                ),
              ),
              Gap(20.h),
              GestureDetector(
                onTap: onPlusButtonClick,
                child: AssetsHelper.svgAddCircle.svg(),
              ),
              Gap(16.w),
            ],
          ),
        ),
      ],
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
          context.l10n.description,
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
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.size,
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
          context.l10n.totalReviewsText(
            shoe.totalReviews.toString(),
          ),
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
                    imageUrl: state.shoeImages?[state.currentImageIndex] ?? '',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            return Positioned(
              left: 37.w,
              bottom: 26.h,
              child: SizedBox(
                height: 8.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      index == state.currentImageIndex
                          ? AssetsHelper.svgSelectedDotIcon.svg()
                          : GestureDetector(
                              onTap: () => context
                                  .read<DetailCubit>()
                                  .setCurrentImage(index),
                              child: AssetsHelper.svgNotSelectedDotIcon.svg(),
                            ),
                  separatorBuilder: (_, __) => Gap(8.w),
                  itemCount: state.shoeImages?.length ?? 0,
                ),
              ),
            );
          },
        ),
        BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            return Positioned(
              right: 10.w,
              bottom: 16.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: 30.circularBorderRadius,
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () =>
                        context.read<DetailCubit>().setCurrentColor(index),
                    child: CustomColorContainer(
                      size: 20.r,
                      color: ColorHelper.getColorFromString(
                        state.shoe?.availableColors[index] ?? red,
                      ),
                      isSelected: index == state.currentColorIndex,
                    ),
                  ),
                  separatorBuilder: (_, __) => Gap(8.w),
                  itemCount: state.shoe?.availableColors.length ?? 0,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
