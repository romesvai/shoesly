part of 'review_cubit.dart';

@freezed
class ReviewState with _$ReviewState {
  const factory ReviewState({
    required ReviewLoadingState reviewLoadingState,
    @Default(true) bool hasMoreDocuments,
    DocumentSnapshot? lastDocument,
    List<ReviewDataModel>? reviews,
    @Default(starsData) List<SelectableDataState> stars,
    String? shoeId,
  }) = _ReviewState;

  const ReviewState._();
}

@freezed
class ReviewLoadingState with _$ReviewLoadingState {
  const factory ReviewLoadingState.initial() = _Initial;

  const factory ReviewLoadingState.loading() = _Loading;

  const factory ReviewLoadingState.paginationLoading() = _PaginationLoading;

  const factory ReviewLoadingState.success() = _Success;

  const factory ReviewLoadingState.xception({BaseException? exception}) =
      _Exception;
}
