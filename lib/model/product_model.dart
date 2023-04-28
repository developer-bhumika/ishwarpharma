import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  bool? success;
  List<ProductDataModel>? data;
  String? message;

  ProductModel({this.success, this.data, this.message});

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class ProductDataModel {
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

  ProductDataModel(
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

  factory ProductDataModel.fromJson(Map<String, dynamic> json) => _$ProductDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDataModelToJson(this);
}
