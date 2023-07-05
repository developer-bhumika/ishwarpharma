import 'package:json_annotation/json_annotation.dart';
part 'focus_product_model.g.dart';

@JsonSerializable()
class FocusProductModel {
  bool? success;
  List<FocusData>? data;
  String? message;

  FocusProductModel({this.success, this.data, this.message});

  factory FocusProductModel.fromJson(Map<String, dynamic> json) =>
      _$FocusProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$FocusProductModelToJson(this);
}

@JsonSerializable()
class FocusData {
  int? id;
  String? image;
  String? created_at;
  String? updated_at;
  String? focusUrl;

  FocusData(
      {this.id, this.image, this.created_at, this.updated_at, this.focusUrl});

  factory FocusData.fromJson(Map<String, dynamic> json) =>
      _$FocusDataFromJson(json);
  Map<String, dynamic> toJson() => _$FocusDataToJson(this);
}
