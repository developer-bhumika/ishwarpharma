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
  String? company;

  CompanyData({this.company});

  factory CompanyData.fromJson(Map<String, dynamic> json) => _$CompanyDataFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyDataToJson(this);
}
