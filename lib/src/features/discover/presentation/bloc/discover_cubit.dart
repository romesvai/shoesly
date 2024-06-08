import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
          final brands =
              brandsResponse.map((brand) => BrandState(brandName: brand));
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
                ? currentlySelectedBrand?.brandName
                : null,
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

  void selectBrand(BrandState selectedBrand) {
    final currentBrands = List<BrandState>.from(state.brands ?? []);
    final updatedBrands = currentBrands.map((brand) {
      if (brand.brandName == selectedBrand.brandName) {
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

    _getShoes(shouldReset: true);
  }

  void fetchAnotherPage() {
    emit(
      state.copyWith(
        discoverLoadingState: const DiscoverLoadingState.paginationLoading(),
      ),
    );
    _getShoes(isForPagination: true);
  }
}
