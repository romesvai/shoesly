import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';
import 'package:shoesly_ps/src/core/enums/gender_type.dart';

part 'get_shoes_usecase_input.freezed.dart';

@freezed
class GetShoesUsecaseInput with _$GetShoesUsecaseInput {
  const factory GetShoesUsecaseInput({
    @Default(defaultPaginationLimit) int limit,
    DocumentSnapshot? lastDocument,
  }) = _GetShoesUsecaseInput;

  const GetShoesUsecaseInput._();
}
