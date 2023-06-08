import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
part 'download_model.g.dart';

@JsonSerializable()
class DownloadModel {
  bool? success;
  List<DownloadDataModel>? data;
  String? message;

  DownloadModel({this.success, this.data, this.message});

  factory DownloadModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadModelToJson(this);
}

@JsonSerializable()
class DownloadDataModel {
  int? id;
  String? name;
  String? price_pdf;
  String? created_at;
  String? updated_at;
  String? pricepdfUrl;
  Rx<bool> load = false.obs;

  DownloadDataModel(
      {this.id,
      this.name,
      this.price_pdf,
      this.created_at,
      this.updated_at,
      this.pricepdfUrl});

  factory DownloadDataModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadDataModelToJson(this);
}
