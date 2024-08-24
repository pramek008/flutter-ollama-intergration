import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable()
class BaseResponse<T> {
  BaseResponse();

  int? statusCode;

  bool? result;
  // bool? isSuccess;

  @JsonKey(ignore: true)
  T? payload;

  String? message;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) map,
  ) {
    final tempResponse = _$BaseResponseFromJson(json);
    final response = BaseResponse<T>()
      ..statusCode = tempResponse.statusCode
      // ..isSuccess = tempResponse.isSuccess
      ..result = tempResponse.result
      ..message = tempResponse.message;
    response.payload = map(json['payload']);
    return response;
  }
}
