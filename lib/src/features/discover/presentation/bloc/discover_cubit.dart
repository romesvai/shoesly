import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';
import 'package:shoesly_ps/src/core/constants/shoesly_constants.dart';
import 'package:shoesly_ps/src/core/exceptions/base_exception.dart';
import 'package:shoesly_ps/src/core/helper/firebase_image_helper.dart';
import 'package:shoesly_ps/src/features/addData/domain/model/add_reviews_usecase_input.dart';
import 'package:shoesly_ps/src/features/addData/domain/model/add_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/addData/domain/usecase/add_reviews_usecase.dart';
import 'package:shoesly_ps/src/features/addData/domain/usecase/add_shoes_usecase.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/get_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/domain/usecase/get_brands_usecase.dart';
import 'package:shoesly_ps/src/features/discover/domain/usecase/get_shoes_usecase.dart';
import 'package:shoesly_ps/src/features/reviews/domain/model/review_data_model.dart';

part 'discover_cubit.freezed.dart';

part 'discover_state.dart';

@injectable
class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(
    this._addShoesUseCase,
    this._addReviewsUseCase,
    this._getShoesUsecase,
    this._getBrandsUsecase,
  ) : super(
          const DiscoverState(
            discoverLoadingState: DiscoverLoadingState.initial(),
          ),
        ) {
    _initialize();
  }

  final AddShoesUsecase _addShoesUseCase;
  final AddReviewsUseCase _addReviewsUseCase;
  final GetShoesUsecase _getShoesUsecase;
  final GetBrandsUsecase _getBrandsUsecase;

  void _initialize() {
    _getShoes();
    _getBrands();
  }

  // ignore: unused_element
  void _addShoes() async {
    _addShoesUseCase
        .execute(
          AddShoesUsecaseInput(shoe: shoes),
        )
        .run();
  }

  // ignore: unused_element
  void _addReviews() async {
    _addReviewsUseCase
        .execute(
          AddReviewsUsecaseInput(
              reviews: generateReviews(),
              shoeDocId: 'e741c649-b627-4b95-853f-abf19e3423bc'),
        )
        .run();
  }

  Future<void> _getBrands() async {
    emit(
      state.copyWith(
        discoverLoadingState: const DiscoverLoadingState.loading(),
      ),
    );

    final response = await _getBrandsUsecase.execute(unit).run();

    emit(
      response.fold(
        (exception) => state.copyWith(
            discoverLoadingState:
                DiscoverLoadingState.xception(exception: exception)),
        (brandsResponse) {
          final brands = brandsResponse
              .map((brand) => SelectableDataState(displayName: brand));
          return state.copyWith(
            brands: [allBrands, ...brands],
          );
        },
      ),
    );
  }

  Future<void> _getShoes({
    bool isForPagination = false,
    bool shouldReset = false,
  }) async {
    emit(
      state.copyWith(
        discoverLoadingState: const DiscoverLoadingState.loading(),
      ),
    );
    final currentlySelectedBrand =
        state.brands?.firstWhere((brand) => brand.isSelected);
    final response = await _getShoesUsecase
        .execute(
          GetShoesUsecaseInput(
            lastDocument: state.lastDocument,
            limit: 4,
            brand: currentlySelectedBrand != allBrands
                ? currentlySelectedBrand?.displayName
                : null,
            priceRange: state.priceRange ==
                    const RangeValues(
                      minPriceValue,
                      maxPriceValue,
                    )
                ? null
                : PriceRangeModel(
                    minPrice: state.priceRange.start,
                    maxPrice: state.priceRange.end,
                  ),
            sortBy: state.sortBy,
            gender: state.gender,
            color: state.color,
          ),
        )
        .run();

    response.match(
      (exception) => emit(
        state.copyWith(
          discoverLoadingState: DiscoverLoadingState.xception(
            exception: exception,
          ),
        ),
      ),
      (shoesResponseModel) async {
        await _getShoesImages(
          shoesResponseModel.shoes,
          isForPagination: isForPagination,
        );
        emit(
          state.copyWith(
            hasMoreDocuments: shoesResponseModel.hasMoreDocuments,
            lastDocument: shoesResponseModel.lastDocument,
            shoes: isForPagination && !shouldReset
                ? [...state.shoes ?? [], ...shoesResponseModel.shoes]
                : shoesResponseModel.shoes,
            discoverLoadingState: const DiscoverLoadingState.success(),
          ),
        );
      },
    );
  }

  Future<void> _getShoesImages(List<ShoeDataModel> shoes,
      {bool isForPagination = false}) async {
    final imageUrlsMap = isForPagination
        ? Map<String, List<String>>.from(
            state.shoeImages ?? {},
          )
        : <String, List<String>>{};
    await Future.wait(
      shoes.map(
        (shoe) async {
          final imageUrls = <String>[];
          for (String imagePath in shoe.images) {
            imageUrls.add(
              await FirebaseImageHelper.getDownloadUrl(imagePath),
            );
          }
          imageUrlsMap[shoe.shoeId] = imageUrls;
        },
      ),
    );

    emit(
      state.copyWith(shoeImages: imageUrlsMap),
    );
  }

  void selectBrand(SelectableDataState selectedBrand,
      {bool shouldFetchData = true}) {
    final currentBrands = List<SelectableDataState>.from(state.brands ?? []);
    final updatedBrands = currentBrands.map((brand) {
      if (brand.displayName == selectedBrand.displayName) {
        return brand.copyWith(isSelected: true);
      } else {
        return brand.copyWith(isSelected: false);
      }
    }).toList();

    emit(
      state.copyWith(
        brands: updatedBrands,
        lastDocument: null,
        hasMoreDocuments: true,
        shoes: null,
      ),
    );
    if (shouldFetchData) {
      _getShoes(shouldReset: true);
    }
  }

  void fetchAnotherPage() {
    if (state.discoverLoadingState == const DiscoverLoadingState.loading()) {
      return;
    }
    emit(
      state.copyWith(
        discoverLoadingState: const DiscoverLoadingState.paginationLoading(),
      ),
    );
    _getShoes(isForPagination: true);
  }

  void onPriceRangeChanged(RangeValues priceRange) {
    emit(
      state.copyWith(priceRange: priceRange),
    );
  }

  void setSortBy({
    required String sortBy,
  }) {
    emit(
      state.copyWith(
        sortBy: sortBy,
      ),
    );
  }

  void setGender({
    required String gender,
  }) {
    emit(
      state.copyWith(
        gender: gender,
      ),
    );
  }

  void setColor({
    required String color,
  }) {
    emit(
      state.copyWith(
        color: color,
      ),
    );
  }

  int getNumberOfAppliedFilters() {
    int filtersApplied = 0;
    final selectedBrand = state.brands?.firstWhere((brand) => brand.isSelected);
    if (state.sortBy != null) {
      filtersApplied++;
    }
    if (state.priceRange != const RangeValues(minPriceValue, maxPriceValue)) {
      filtersApplied++;
    }
    if (selectedBrand?.displayName != allBrands.displayName) {
      filtersApplied++;
    }
    if (state.gender != null) {
      filtersApplied++;
    }
    if (state.color != null) {
      filtersApplied++;
    }
    return filtersApplied;
  }

  void resetFilters() {
    emit(
      state.copyWith(
        sortBy: null,
        priceRange: const RangeValues(
          minPriceValue,
          maxPriceValue,
        ),
        gender: null,
        color: null,
      ),
    );

    selectBrand(
      allBrands,
      shouldFetchData: true,
    );
  }

  void applyFilter() {
    if (getNumberOfAppliedFilters() == 0) {
      return;
    }
    emit(
      state.copyWith(
        filterApplied: true,
      ),
    );
    emit(
      state.copyWith(
        lastDocument: null,
        hasMoreDocuments: true,
      ),
    );
    _getShoes(shouldReset: true);
  }

  void resetFilterAppliedFlag() {
    emit(
      state.copyWith(filterApplied: false),
    );
  }
}
