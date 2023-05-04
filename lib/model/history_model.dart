import 'package:json_annotation/json_annotation.dart';
part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  bool? success;
  List<HistoryData>? data;
  String? message;

  HistoryModel({this.success, this.data, this.message});

  factory HistoryModel.fromJson(Map<String, dynamic> json) => _$HistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}

@JsonSerializable()
class HistoryData {
  int? id;
  String? device_id;
  String? firm_name;
  String? place;
  String? mobile_number;
  String? email;
  String? final_total;
  String? status;
  String? created_at;
  String? updated_at;
  List<Products>? products;

  HistoryData(
      {this.id,
      this.device_id,
      this.firm_name,
      this.place,
      this.mobile_number,
      this.email,
      this.final_total,
      this.status,
      this.created_at,
      this.updated_at,
      this.products});

  factory HistoryData.fromJson(Map<String, dynamic> json) => _$HistoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryDataToJson(this);
}

@JsonSerializable()
class Products {
  String? order_id;
  String? product_id;
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

  Products(
      {this.order_id,
      this.product_id,
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

  factory Products.fromJson(Map<String, dynamic> json) => _$ProductsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}
