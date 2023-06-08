import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
part 'download_product_model.g.dart';

@JsonSerializable()
class DownLoadProductModel {
  bool? success;
  List<DownloadProductDataModel>? data;
  String? message;

  DownLoadProductModel({this.success, this.data, this.message});

  factory DownLoadProductModel.fromJson(Map<String, dynamic> json) =>
      _$DownLoadProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownLoadProductModelToJson(this);
}

@JsonSerializable()
class DownloadProductDataModel {
  int? id;
  String? name;
  String? price_pdf;
  String? created_at;
  String? updated_at;
  String? productpdfUrl;
  Rx<bool> load = false.obs;

  DownloadProductDataModel(
      {this.id,
      this.name,
      this.price_pdf,
      this.created_at,
      this.updated_at,
      this.productpdfUrl});

  factory DownloadProductDataModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadProductDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadProductDataModelToJson(this);
}
