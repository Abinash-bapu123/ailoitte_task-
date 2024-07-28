// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitRepo _$GitRepoFromJson(Map<String, dynamic> json) => GitRepo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GitRepoToJson(GitRepo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
