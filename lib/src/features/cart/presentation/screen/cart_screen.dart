import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/number_extensions.dart';
import 'package:shoesly_ps/src/core/extensions/string_extensions.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/themes/typography/app_text_theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_app_bar.dart';
import 'package:shoesly_ps/src/core/widgets/custom_data_fetching_loader.dart';
import 'package:shoesly_ps/src/core/widgets/custom_rounded_container.dart';
import 'package:shoesly_ps/src/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:shoesly_ps/src/features/product_detail/presentation/screens/detail_screen.dart';

@RoutePage()
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.cart),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems == null) {
            return const CustomDataFetchingLoader();
          }
          if (state.cartItems!.isEmpty) {
            return Center(
              child: Text(l10n.cartIsEmpty),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            child: Column(
              children: [
                Gap(30.h),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final cartItem = state.cartItems![index];
                    return Dismissible(
                      key: Key(
                        cartItem.id,
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        context.read<CartCubit>().removeCartItem(cartItem);

                        context.showSnackBar(
                          Text(
                            l10n.cartItemRemoved,
                          ),
                        );
                      },
                      background: CustomRoundedContainer(
                        borderRadius: 16.circularBorderRadius,
                        height: 88.h,
                        width: double.infinity,
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.only(
                          right: 12.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AssetsHelper.svgTrash.svg(),
                        ),
                      ),
                      child: Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomRoundedContainer(
                                height: 88.r,
                                width: 88.r,
                                borderRadius: 20.circularBorderRadius,
                                child: ClipRRect(
                                  borderRadius: 20.circularBorderRadius,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        state.cartItemImageMap[cartItem.id]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Gap(15.w),
                              SizedBox(
                                height: 88.h,
                                width: context.width * 0.54,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.itemName,
                                      style: AppTextTheme.titleMedium,
                                    ),
                                    Gap(8.h),
                                    Text(
                                      '${cartItem.brand} . ${cartItem.color.capitalize()} . ${cartItem.size}',
                                      style: AppTextTheme.bodySmall.copyWith(
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    PriceQuantityRowWidget(
                                      quantity: cartItem.quantity,
                                      onMinusButtonClick: () => context
                                          .read<CartCubit>()
                                          .decreaseCartItemQuantity(cartItem),
                                      onPlusButtonClick: () => context
                                          .read<CartCubit>()
                                          .increaseCartItemQuantity(cartItem),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Gap(30.h),
                  itemCount: state.cartItems!.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
