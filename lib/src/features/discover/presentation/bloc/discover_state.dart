part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    required DiscoverLoadingState discoverLoadingState,
    @Default(true) bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
    List<ShoeDataModel>? shoes,
  }) = _DiscoverState;

  const DiscoverState._();
}

@freezed
class DiscoverLoadingState with _$DiscoverLoadingState {
  const factory DiscoverLoadingState.initial() = _Initial;

  const factory DiscoverLoadingState.loading() = _Loading;

  const factory DiscoverLoadingState.success() = _Success;

  const factory DiscoverLoadingState.xception({BaseException? exception}) =
      _Exception;
}
