part of 'detail_cubit.dart';

@freezed
class DetailState with _$DetailState {
  const factory DetailState({
    required DetailLoadingState detailLoadingState,
    ShoeDataModel? shoe,
    List<String>? shoeImages,
    List<ReviewDataModel>? reviews,
    double? selectedSize,
    @Default(0) currentImageIndex,
    @Default(0) currentColorIndex,
  }) = _DetailState;

  const DetailState._();
}

@freezed
class DetailLoadingState with _$DetailLoadingState {
  const factory DetailLoadingState.initial() = _Initial;

  const factory DetailLoadingState.loading() = _Loading;

  const factory DetailLoadingState.success() = _Success;

  const factory DetailLoadingState.xception({BaseException? exception}) =
      _Exception;
}
