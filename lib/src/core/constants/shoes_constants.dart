import 'package:shoesly_ps/src/features/discover/domain/model/shoe_data_model.dart';

final now = DateTime.now();
List<ShoeDataModel> shoes = [
  ShoeDataModel(
    name: 'Jordan 1 Retro High Tie Dye',
    brand: 'Jordan',
    price: 235.00,
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
      'images/img-1.png',
      'images/jordan1.avif',
      'images/jordan2.png',
    ],
    releaseDate: DateTime(
      now.year,
      now.month - 1,
      now.day,
      now.hour,
      now.minute,
    ),
  )
];
