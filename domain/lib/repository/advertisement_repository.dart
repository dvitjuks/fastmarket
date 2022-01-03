import 'dart:async';

import 'package:domain/model/advertisement.dart';

abstract class AdvertisementRepository {
  Future<void> publishAdvertisement(Advertisement advert);

  Future<List<Advertisement>> getAdvertisements(String? category);

  Future<List<Advertisement>> getMoreAdvertisements(String? category);

  Future<List<Advertisement>> getMyAdvertisements();

  Future<List<Advertisement>> getMoreMyAdvertisements();

  Future<void> deleteAdvertisement(Advertisement advert);

  bool get canLoadMore;

  bool get canLoadMoreMyAdverts;

  Stream<void> refreshStream();
}
