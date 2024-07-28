import 'dart:convert';

import 'package:ailoitte_task/config/app_constants.dart';
import 'package:ailoitte_task/data/models/git_repo_model.dart';
import 'package:http/http.dart' as http;

class GitRepoRepository {
  static Future<List<GitRepo>> getRepos(String? repoDate) async {
    final url =
        "${AppConstants.baseURL}search/repositories?q=created:%3E$repoDate&sort=stars&order=desc";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['items'] as List;
        return data.map((items) => GitRepo.fromJson(items)).toList();
      } else {
        throw Exception(res.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Unable to Fetch Data");
    }
  }
}
