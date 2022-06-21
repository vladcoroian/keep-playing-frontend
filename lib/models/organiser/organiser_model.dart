import 'package:json_annotation/json_annotation.dart';

part 'organiser_model.g.dart';

@JsonSerializable()
class OrganiserModel {
  final List<int> favourites;
  final List<int> blocked;

  OrganiserModel({
    required this.favourites,
    required this.blocked,
  });

  factory OrganiserModel.fromJson(Map<String, dynamic> json) =>
      _$OrganiserModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrganiserModelToJson(this);
}
