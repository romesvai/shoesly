import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/constants/shoes_constants.dart';
import 'package:shoesly_ps/src/features/addData/domain/models/add_shoes_usecase_input.dart';
import 'package:shoesly_ps/src/features/addData/domain/usecases/add_shoes_usecase.dart';

part 'discover_cubit.freezed.dart';
part 'discover_state.dart';

@injectable
class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(this._addShoesUseCase) : super(const DiscoverState());

  final AddShoesUsecase _addShoesUseCase;

  void addShoes() async {
    _addShoesUseCase
        .execute(
          AddShoesUsecaseInput(shoes: shoes),
        )
        .run();
  }
}
