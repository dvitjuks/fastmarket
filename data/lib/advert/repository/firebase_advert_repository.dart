import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/images/profile_avatar/repository/firebase_images_storage_repository.dart';
import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirebaseAdvertRepository extends AdvertisementRepository {
  final FireBaseImagesStorageRepository _fireBaseImagesStorageRepository;
  final StreamController<void> _refreshController = BehaviorSubject();

  @override
  Stream<void> refreshStream() => _refreshController.stream;

  FirebaseAdvertRepository(this._fireBaseImagesStorageRepository);

  final _advertsRef = FirebaseFirestore.instance
      .collection('adverts')
      .withConverter<Advertisement>(
          fromFirestore: (snapshot, _) =>
              Advertisement.fromJson(snapshot.data()!),
          toFirestore: (advert, _) => advert.toJson());

  DocumentSnapshot<Advertisement>? lastAdvert;
  DocumentSnapshot<Advertisement>? myLastAdvert;
  bool _canLoadMore = true;
  bool _canLoadMoreMyAdverts = true;

  @override
  Future<void> publishAdvertisement(Advertisement advert) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var uuid = const Uuid();
      final adId = advert.adId.isEmpty ? uuid.v4() : advert.adId;
      try {
        await _advertsRef
            .doc(adId)
            .set(advert.copyWith(adId: adId, ownerId: userId));
        _refreshController.add(null);
        return;
      } catch (ex, st) {
        Fimber.w("Failed to publish advert", ex: ex, stacktrace: st);
        throw AppError(ErrorType.addAdvert);
      }
    } else {
      Fimber.w("Failed to get current user");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<List<Advertisement>> getAdvertisements(String? category) async {
    List<DocumentSnapshot<Advertisement>> firstAdvertBatch;
    List<Advertisement> mappedAdverts = [];
    if (category != "All categories") {
      firstAdvertBatch = await _advertsRef
          .where('category', isEqualTo: category)
          .orderBy("createdAt", descending: true)
          .limit(20)
          .get()
          .then((value) => value.docs);
      lastAdvert = firstAdvertBatch.isNotEmpty ? firstAdvertBatch.last : null;
      for (var snapshot in firstAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    } else {
      firstAdvertBatch =
          await _advertsRef.limit(20).get().then((value) => value.docs);
      lastAdvert = firstAdvertBatch.isNotEmpty ? firstAdvertBatch.last : null;
      for (var snapshot in firstAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    }
    _canLoadMore = mappedAdverts.length == 20;
    return mappedAdverts;
  }

  @override
  Future<List<Advertisement>> getMoreAdvertisements(String? category) async {
    List<DocumentSnapshot<Advertisement>> nextAdvertBatch;
    List<Advertisement> mappedAdverts = [];
    if (category != "All categories") {
      nextAdvertBatch = await _advertsRef
          .where('category', isEqualTo: category)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(lastAdvert!)
          .limit(20)
          .get()
          .then((value) => value.docs);
      lastAdvert = nextAdvertBatch.isNotEmpty ? nextAdvertBatch.last : null;
      for (var snapshot in nextAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    } else {
      nextAdvertBatch = await _advertsRef
          .startAfterDocument(lastAdvert!)
          .limit(20)
          .get()
          .then((value) => value.docs);
      lastAdvert = nextAdvertBatch.isNotEmpty ? nextAdvertBatch.last : null;
      for (var snapshot in nextAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    }
    _canLoadMore = mappedAdverts.length == 20;
    return mappedAdverts;
  }

  @override
  bool get canLoadMore => _canLoadMore;

  @override
  bool get canLoadMoreMyAdverts => _canLoadMoreMyAdverts;

  @override
  Future<void> deleteAdvertisement(Advertisement advert) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final ownerId = advert.ownerId;
    if (userId != null && userId == ownerId) {
      try {
        _fireBaseImagesStorageRepository.deleteAdvertImage(advert);
        _advertsRef.doc(advert.adId).delete();
        _refreshController.add(null);
      } catch (ex, st) {
        Fimber.w("Failed to delete an advert", ex: ex, stacktrace: st);
        throw AppError(ErrorType.generalError);
      }
    } else {
      Fimber.w(
          "Can't delete this advertisement, you are either not authorized or aren't owner of the advert");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<List<Advertisement>> getMoreMyAdvertisements() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      List<DocumentSnapshot<Advertisement>> nextMyAdvertBatch;
      List<Advertisement> mappedAdverts = [];
      nextMyAdvertBatch = await _advertsRef
          .where('ownerId', isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(lastAdvert!)
          .limit(20)
          .get()
          .then((value) => value.docs);
      myLastAdvert =
          nextMyAdvertBatch.isNotEmpty ? nextMyAdvertBatch.last : null;
      for (var snapshot in nextMyAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
      _canLoadMoreMyAdverts = mappedAdverts.length == 20;
      return mappedAdverts;
    } else {
      Fimber.w("Can't load user's adverts because user is not authorized");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<List<Advertisement>> getMyAdvertisements() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      List<DocumentSnapshot<Advertisement>> firstMyAdvertBatch;
      List<Advertisement> mappedAdverts = [];
      firstMyAdvertBatch = await _advertsRef
          .where('ownerId', isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .limit(20)
          .get()
          .then((value) => value.docs);
      myLastAdvert =
          firstMyAdvertBatch.isNotEmpty ? firstMyAdvertBatch.last : null;
      for (var snapshot in firstMyAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
      _canLoadMoreMyAdverts = mappedAdverts.length == 20;
      return mappedAdverts;
    } else {
      Fimber.w("Can't load user's adverts because user is not authorized");
      throw AppError(ErrorType.generalError);
    }
  }
}
