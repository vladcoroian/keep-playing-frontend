// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organiser_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganiserModel _$OrganiserModelFromJson(Map<String, dynamic> json) =>
    OrganiserModel(
      favourite:
          (json['favourite'] as List<dynamic>).map((e) => e as int).toList(),
      blocked: (json['blocked'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$OrganiserModelToJson(OrganiserModel instance) =>
    <String, dynamic>{
      'favourite': instance.favourite,
      'blocked': instance.blocked,
    };
