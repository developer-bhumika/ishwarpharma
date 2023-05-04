import 'package:json_annotation/json_annotation.dart';
part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  bool? success;
  List<CartData>? data;
  String? message;

  CartModel({this.success, this.data, this.message});

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

@JsonSerializable()
class CartData {
  int? id;
  String? product_id;
  String? device_id;
  String? brand_name;
  String? company;
  String? pack;
  String? content;
  String? rate;
  String? scheme;
  String? mrp;
  String? qty;
  String? amount;
  String? created_at;
  String? updated_at;

  CartData(
      {this.id,
      this.product_id,
      this.device_id,
      this.brand_name,
      this.company,
      this.pack,
      this.content,
      this.rate,
      this.scheme,
      this.mrp,
      this.qty,
      this.amount,
      this.created_at,
      this.updated_at});

  factory CartData.fromJson(Map<String, dynamic> json) => _$CartDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}
