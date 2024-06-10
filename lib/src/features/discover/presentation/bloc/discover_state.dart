part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    required DiscoverLoadingState discoverLoadingState,
    @Default(true) bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
    List<ShoeDataModel>? shoes,
    Map<String, List<String>>? shoeImages,
    List<SelectableDataState>? brands,
    @Default(RangeValues(minPriceValue, maxPriceValue)) RangeValues priceRange,
    String? sortBy,
    String? gender,
    String? color,
    @Default(false) filterApplied,
  }) = _DiscoverState;

  const DiscoverState._();
}

@freezed
class SelectableDataState with _$SelectableDataState {
  const factory SelectableDataState({
    required String displayName,
    @Default(false) bool isSelected,
  }) = _SelectableDataState;

  const SelectableDataState._();
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
