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
  //Use images repository when handling advert deletion
  final FireBaseImagesStorageRepository _fireBaseImagesStorageRepository;
  //Stream to notify pages to refresh adverts
  final StreamController<void> _refreshController = BehaviorSubject();

  @override
  //Refresh stream accessor
  Stream<void> refreshStream() => _refreshController.stream;

  FirebaseAdvertRepository(this._fireBaseImagesStorageRepository);

  //Reference to firestore instance with converter type of Advertisement
  final _advertsRef = FirebaseFirestore.instance
      .collection('adverts')
      .withConverter<Advertisement>(
          fromFirestore: (snapshot, _) =>
              Advertisement.fromJson(snapshot.data()!),
          toFirestore: (advert, _) => advert.toJson());

  //Remember last loaded advert to use pagination (only way firebase allows)
  DocumentSnapshot<Advertisement>? lastAdvert;
  DocumentSnapshot<Advertisement>? myLastAdvert;
  //Remember if there are more items to load to save on excess calls to firestore
  bool _canLoadMore = true;
  bool _canLoadMoreMyAdverts = true;

  @override
  Future<void> publishAdvertisement(Advertisement advert) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    //Check if user is logged in
    if (userId != null) {
      //Generate unique ad ID
      var uuid = const Uuid();
      final adId = advert.adId.isEmpty ? uuid.v4() : advert.adId;
      try {
        //Add created advert to firestore
        await _advertsRef
            .doc(adId)
            .set(advert.copyWith(adId: adId, ownerId: userId));
        //After adding new advert, trigger refresh stream, as advert list changed
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
    //If any exact category is chosen
    if (category != "All categories") {
      //Request first 20 documents of selected category (for pagination)
      firstAdvertBatch = await _advertsRef
          .where('category', isEqualTo: category)
          .orderBy("createdAt", descending: true)
          .limit(20)
          .get()
          .then((value) => value.docs);
      //Remember last document of the batch for future pagination
      lastAdvert = firstAdvertBatch.isNotEmpty ? firstAdvertBatch.last : null;
      //Map through DocumentSnapshots and fill mappedAdverts list
      for (var snapshot in firstAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    } else { //If "All Categories" is selected
      //Load just first 20 of all adverts
      firstAdvertBatch =
          await _advertsRef.limit(20).get().then((value) => value.docs);
      //Remember last document of the batch for future pagination
      lastAdvert = firstAdvertBatch.isNotEmpty ? firstAdvertBatch.last : null;
      //Map through DocumentSnapshots and fill mappedAdverts list
      for (var snapshot in firstAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    }
    //If mapped adverts length is < 20, then there are no more adverts to load
    _canLoadMore = mappedAdverts.length == 20;
    return mappedAdverts;
  }

  @override
  Future<List<Advertisement>> getMoreAdvertisements(String? category) async {
    List<DocumentSnapshot<Advertisement>> nextAdvertBatch;
    List<Advertisement> mappedAdverts = [];
    //If any exact category is chosen
    if (category != "All categories") {
      //Request next 20 documents of selected category
      nextAdvertBatch = await _advertsRef
          .where('category', isEqualTo: category)
          .orderBy("createdAt", descending: true)
      //Use saved lastAdvert of previous batch to set starting point
          .startAfterDocument(lastAdvert!)
          .limit(20)
          .get()
          .then((value) => value.docs);
      //Remember last document of the batch for future pagination
      lastAdvert = nextAdvertBatch.isNotEmpty ? nextAdvertBatch.last : null;
      //Map through DocumentSnapshots and fill mappedAdverts list
      for (var snapshot in nextAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    } else { //If "All Categories" is selected
      //Request next 20 documents of selected category
      nextAdvertBatch = await _advertsRef
      //Use saved last advert from last batch
          .startAfterDocument(lastAdvert!)
          .limit(20)
          .get()
          .then((value) => value.docs);
      //Remember last document of the batch for future pagination
      lastAdvert = nextAdvertBatch.isNotEmpty ? nextAdvertBatch.last : null;
      //Map through DocumentSnapshots and fill mappedAdverts list
      for (var snapshot in nextAdvertBatch) {
        final advert = snapshot.data();
        if (advert != null) {
          mappedAdverts.add(advert);
        }
      }
    }
    //If mapped adverts length is < 20, then there are no more adverts to load
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
    //Check if user is logged in and is the owner of deletable advert
    if (userId != null && userId == ownerId) {
      try {
        //First delete image from Firebase Storage
        _fireBaseImagesStorageRepository.deleteAdvertImage(advert);
        //Then delete document from Firestore
        _advertsRef.doc(advert.adId).delete();
        //After deleting advert, trigger refresh stream, as advert list changed
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

  //Basically the same as getMoreAdvertisements, but without category
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

  //Basically the same as getAdvertisements, but without category
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

  @override
  Future<void> saveAdvertisement(Advertisement advert) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    //Check if user is logged in
    if (userId != null) {
      try {
        //Save advert changes in Firestore
        await _advertsRef
            .doc(advert.adId)
            .set(advert);
        //After saving advert, trigger refresh stream, as advert changed
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
}
