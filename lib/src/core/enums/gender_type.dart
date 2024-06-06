import 'package:freezed_annotation/freezed_annotation.dart';

enum GenderType {
  @JsonValue('man')
  man,
  @JsonValue('woman')
  woman,
  @JsonValue('unisex')
  unisex,
}
