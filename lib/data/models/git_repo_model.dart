import 'package:json_annotation/json_annotation.dart';

part 'git_repo_model.g.dart';

@JsonSerializable()
class GitRepo {
  final int id;
  final String? name;
  final String? description;
  GitRepo({
    required this.id,
    required this.name,
    this.description,
  });

  factory GitRepo.fromJson(Map<String, dynamic> json) =>
      _$GitRepoFromJson(json);
  Map<String, dynamic> toJson() => _$GitRepoToJson(this);
}
