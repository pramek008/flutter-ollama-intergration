// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(Map<String, dynamic> json) =>
    BaseResponse<T>()
      ..statusCode = (json['statusCode'] as num?)?.toInt()
      ..result = json['result'] as bool?
      ..message = json['message'] as String?;

Map<String, dynamic> _$BaseResponseToJson<T>(BaseResponse<T> instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'result': instance.result,
      'message': instance.message,
    };
