import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

part 'add_shoes_usecase_input.freezed.dart';

@freezed
class AddShoesUsecaseInput with _$AddShoesUsecaseInput {
  const factory AddShoesUsecaseInput({
    required List<ShoeDataModel> shoes,
  }) = _AddShoesUsecaseInput;

  const AddShoesUsecaseInput._();
}
