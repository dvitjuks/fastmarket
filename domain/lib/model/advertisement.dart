import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'advertisement.g.dart';

@JsonSerializable()
class Advertisement extends Equatable {
  final String adId;
  final String ownerId;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final String? imageUrl;
  final String? contactPhone;
  final String? address;
  final String? latitude;
  final String? longitude;

  const Advertisement(
      {required this.adId,
      required this.ownerId,
      required this.title,
      required this.description,
      required this.category,
      required this.createdAt,
      this.imageUrl,
      this.contactPhone,
      this.address,
      this.latitude,
      this.longitude});

  Advertisement copyWith(
          {String? adId,
          String? ownerId,
          String? title,
          String? description,
          String? category,
          DateTime? createdAt,
          String? imageUrl,
          String? contactPhone,
          String? address,
          String? latitude,
          String? longitude}) =>
      Advertisement(
          adId: adId ?? this.adId,
          ownerId: ownerId ?? this.ownerId,
          title: title ?? this.title,
          description: description ?? this.description,
          category: category ?? this.category,
          createdAt: createdAt ?? this.createdAt,
          imageUrl: imageUrl ?? this.imageUrl,
          contactPhone: contactPhone ?? this.contactPhone,
          address: address ?? this.address,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude);

  factory Advertisement.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisementToJson(this);

  @override
  List<Object?> get props => [
        adId,
        ownerId,
        title,
        description,
        category,
        createdAt,
        imageUrl,
        contactPhone,
        address,
        latitude,
        longitude
      ];
}
