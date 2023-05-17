import 'package:json_annotation/json_annotation.dart';
part 'slider_model.g.dart';

@JsonSerializable()
class SliderModel {
  bool? success;
  List<SliderDataModel>? data;
  String? message;

  SliderModel({this.success, this.data, this.message});

  factory SliderModel.fromJson(Map<String, dynamic> json) => _$SliderModelFromJson(json);
  Map<String, dynamic> toJson() => _$SliderModelToJson(this);
}

@JsonSerializable()
class SliderDataModel {
  int? id;
  String? image;
  String? created_at;
  String? updated_at;
  String? sliderUrl;

  SliderDataModel({this.id, this.image, this.created_at, this.updated_at, this.sliderUrl});

  factory SliderDataModel.fromJson(Map<String, dynamic> json) => _$SliderDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SliderDataModelToJson(this);
}
