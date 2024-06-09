import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly_ps/src/features/discover/data/model/shoes_response_model.dart';

abstract class ShoesRepository {
  Future<ShoesResponseModel> getShoes({
    DocumentSnapshot? lastDocument,
    int limit = 10,
    String? brand,
  });
  
  Future<List<String>> getBrands();
}
