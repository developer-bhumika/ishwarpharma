import 'package:json_annotation/json_annotation.dart';
part 'new_arrival_model.g.dart';

@JsonSerializable()
class NewArrivalModel {
  bool? success;
  List<NewArrivalData>? data;
  String? message;

  NewArrivalModel({this.success, this.data, this.message});

  factory NewArrivalModel.fromJson(Map<String, dynamic> json) =>
      _$NewArrivalModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewArrivalModelToJson(this);
}

@JsonSerializable()
class NewArrivalData {
  int? id;
  String? image;
  String? created_at;
  String? updated_at;
  String? arrivalUrl;

  NewArrivalData(
      {this.id, this.image, this.created_at, this.updated_at, this.arrivalUrl});

  factory NewArrivalData.fromJson(Map<String, dynamic> json) =>
      _$NewArrivalDataFromJson(json);
  Map<String, dynamic> toJson() => _$NewArrivalDataToJson(this);
}
