import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shoesly_ps/src/core/extensions/datetime_extension.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_cached_network_image.dart';
import 'package:shoesly_ps/src/core/widgets/custom_ratings_bar.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';
import 'package:shoesly_ps/src/features/reviews/presentation/bloc/review_cubit.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget(
      {super.key,
      required this.reviews,
      this.showPaginationLoading = false,
      this.onPaginate,
      this.isForPaginatingList = false});

  const ReviewWidget.reviewsList({
    super.key,
    required this.reviews,
    this.showPaginationLoading = false,
    this.onPaginate,
    this.isForPaginatingList = true,
  });

  final List<ReviewDataModel> reviews;
  final bool showPaginationLoading;
  final VoidCallback? onPaginate;

  final bool isForPaginatingList;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final reviewsScrollController = ScrollController();

  void _initScrollListener() {
    reviewsScrollController.addListener(() {
      if (reviewsScrollController.position.maxScrollExtent ==
              reviewsScrollController.position.pixels &&
          (context.read<ReviewCubit>().state.hasMoreDocuments)) {
        if (context.read<ReviewCubit>().state.reviewLoadingState !=
            const ReviewLoadingState.paginationLoading()) {
          widget.onPaginate?.call();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initScrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: reviewsScrollController,
      physics: widget.isForPaginatingList
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == widget.reviews.length) {
          if (widget.showPaginationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.textBlack,
              ),
            );
          } else {
            return const SizedBox();
          }
        }
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCachedNetworkImage(
                  imageUrl: 'https://picsum.photos/seed/$index/200/300',
                  imageBuilder: (_, imageProvider) => CircleAvatar(
                    radius: 25,
                    backgroundImage: imageProvider,
                  ),
                ),
                Gap(15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reviews[index].reviewerName,
                        style: AppTextTheme.displaySmall.copyWith(
                          fontSize: 14,
                          color: AppColors.textBlackReview,
                        ),
                      ),
                      Gap(5.h),
                      CustomRatingsBar(
                        ratingValue: widget.reviews[index].reviewStars,
                      ),
                      Gap(10.h),
                      Text(
                        widget.reviews[index].description,
                        style: AppTextTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.reviews[index].reviewDate.formattedDate,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                // Text()
              ],
            )
          ],
        );
      },
      itemCount: widget.reviews.length + 1,
      separatorBuilder: (_, __) => Gap(30.h),
    );
  }
}
