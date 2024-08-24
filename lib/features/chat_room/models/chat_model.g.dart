// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      model: json['model'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      response: json['response'] as String?,
      done: json['done'] as bool?,
      doneReason: json['done_reason'] as String?,
      context: (json['context'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      totalDuration: (json['total_duration'] as num?)?.toInt(),
      loadDuration: (json['load_duration'] as num?)?.toInt(),
      promptEvalCount: (json['prompt_eval_count'] as num?)?.toInt(),
      promptEvalDuration: (json['prompt_eval_duration'] as num?)?.toInt(),
      evalCount: (json['eval_count'] as num?)?.toInt(),
      evalDuration: (json['eval_duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'model': instance.model,
      'created_at': instance.createdAt?.toIso8601String(),
      'response': instance.response,
      'done': instance.done,
      'done_reason': instance.doneReason,
      'context': instance.context,
      'total_duration': instance.totalDuration,
      'load_duration': instance.loadDuration,
      'prompt_eval_count': instance.promptEvalCount,
      'prompt_eval_duration': instance.promptEvalDuration,
      'eval_count': instance.evalCount,
      'eval_duration': instance.evalDuration,
    };
