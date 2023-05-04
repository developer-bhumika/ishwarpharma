import 'package:json_annotation/json_annotation.dart';
part 'product_detail_model.g.dart';

@JsonSerializable()
class ProductDetailModel {
  bool? success;
  ProductDetailData? data;
  String? message;

  ProductDetailModel({this.success, this.data, this.message});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => _$ProductDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);
}

@JsonSerializable()
class ProductDetailData {
  int? id;
  String? brand;
  String? key;
  String? pack;
  String? rate;
  String? mrp;
  @JsonKey(name: 'case')
  String? productCase;
  String? content;
  String? company;
  String? unit_value;
  String? case_value;
  String? type;
  String? free_scheme;
  String? created_at;
  String? updated_at;

  ProductDetailData(
      {this.id,
      this.brand,
      this.key,
      this.pack,
      this.rate,
      this.mrp,
      this.productCase,
      this.content,
      this.company,
      this.unit_value,
      this.case_value,
      this.type,
      this.free_scheme,
      this.created_at,
      this.updated_at});

  factory ProductDetailData.fromJson(Map<String, dynamic> json) => _$ProductDetailDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailDataToJson(this);
}
