import 'package:json_annotation/json_annotation.dart';
part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  bool? success;
  List<CompanyData>? data;
  String? message;

  CompanyModel({this.success, this.data, this.message});

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}

@JsonSerializable()
class CompanyData {
  int? id;
  String? name;
  String? logo;
  String? created_at;
  String? updated_at;
  String? logoUrl;

  CompanyData({this.id, this.name, this.logo, this.created_at, this.updated_at, this.logoUrl});

  factory CompanyData.fromJson(Map<String, dynamic> json) => _$CompanyDataFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyDataToJson(this);
}
