import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatResponseModel {
  @JsonKey(name: "model")
  String? model;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "response")
  String? response;
  @JsonKey(name: "done")
  bool? done;
  @JsonKey(name: "done_reason")
  String? doneReason;
  @JsonKey(name: "context")
  List<int>? context;
  @JsonKey(name: "total_duration")
  int? totalDuration;
  @JsonKey(name: "load_duration")
  int? loadDuration;
  @JsonKey(name: "prompt_eval_count")
  int? promptEvalCount;
  @JsonKey(name: "prompt_eval_duration")
  int? promptEvalDuration;
  @JsonKey(name: "eval_count")
  int? evalCount;
  @JsonKey(name: "eval_duration")
  int? evalDuration;

  ChatResponseModel({
    this.model,
    this.createdAt,
    this.response,
    this.done,
    this.doneReason,
    this.context,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}
