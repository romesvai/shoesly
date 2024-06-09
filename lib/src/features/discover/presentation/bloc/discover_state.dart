part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    required DiscoverLoadingState discoverLoadingState,
    @Default(true) bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
    List<ShoeDataModel>? shoes,
    Map<String, List<String>>? shoeImages,
    List<BrandState>? brands,
  }) = _DiscoverState;

  const DiscoverState._();
}

@freezed
class BrandState with _$BrandState {
  const factory BrandState({
    required String brandName,
    @Default(false) bool isSelected,
  }) = _BrandState;

  const BrandState._();
}

@freezed
class DiscoverLoadingState with _$DiscoverLoadingState {
  const factory DiscoverLoadingState.initial() = _Initial;

  const factory DiscoverLoadingState.loading() = _Loading;

  const factory DiscoverLoadingState.paginationLoading() = _PaginationLoading;

  const factory DiscoverLoadingState.success() = _Success;

  const factory DiscoverLoadingState.xception({BaseException? exception}) =
      _Exception;
}
