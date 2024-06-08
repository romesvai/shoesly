import 'package:shoesly_ps/src/core/constants/string_constants.dart';
import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';
import 'package:shoesly_ps/src/features/discover/presentation/bloc/discover_cubit.dart';
import 'package:uuid/uuid.dart';

final now = DateTime.now();
final ShoeDataModel shoes = ShoeDataModel(
  shoeId: const Uuid().v4(),
  name: 'Nike Ash Air',
  brand: 'Nike',
  price: 190.00,
  availableSizes: [
    39,
    39.5,
    40,
    40.5,
    41,
  ],
  description:
      'Engineered to crush any movement-based workout, these On sneakers enhance the label\'s original Cloud sneaker with cutting edge technologies for a pair.',
  availableColors: ['red', 'blue', 'yellow', 'black', 'white'],
  images: [
    'images/nike1.png',
    'images/nike3.png',
    'images/nike4.png',
  ],
  releaseDate: DateTime(
    now.year,
    now.month - 1,
    now.day,
    now.hour,
    now.minute,
  ),
);

const allBrands = BrandState(
  brandName: brandAll,
  isSelected: true,
);
