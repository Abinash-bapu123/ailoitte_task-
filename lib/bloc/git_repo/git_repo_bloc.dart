import 'dart:async';
import 'package:ailoitte_task/data/models/git_repo_model.dart';
import 'package:ailoitte_task/data/repository/git_repo_repository.dart';
import 'package:ailoitte_task/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'git_repo_event.dart';
part 'git_repo_state.dart';

class GitRepoBloc extends Bloc<GitRepoEvent, GitRepoState> {
  GitRepoBloc() : super(GitRepoInitial()) {
    on<FetchGitRepos>(getGitRepo);
    on<FetchGitReposForToday>(getGitRepoForToday);
  }

  void getGitRepo(FetchGitRepos event, Emitter<GitRepoState> emit) async {
    emit(GitRepoLoading());
    final dbHelper = DbHelper();
    List<GitRepo> gitReposLocal = [];
    String repoDate = "2022-04-29";
    try {
      if (gitReposLocal.isEmpty) {
        final gitReposApiData = await GitRepoRepository.getRepos(repoDate);
        await dbHelper.insertRepositories(gitReposApiData);
        gitReposLocal = await dbHelper.getRepositories();
      }
      if (gitReposLocal.isEmpty) {
        emit(const GitRepoError("No Result Found for Today"));
      } else {
        emit(GitRepoLoaded(gitReposLocal));
      }
    } catch (e) {
      emit(const GitRepoError("Unable to Load Results"));
    }
  }

  void getGitRepoForToday(
      FetchGitReposForToday event, Emitter<GitRepoState> emit) async {
    final dbHelper = DbHelper();
    List<GitRepo> gitReposLocal = [];
    String repoDate = DateTime.now().toString().split(' ').first;
    try {
      await dbHelper.clearRepositories();
      ComputeApiHelper computeApiHelper = ComputeApiHelper(
        repoDate: repoDate,
      );
      final gitReposApiData = await compute(_computeApiAndDb, computeApiHelper);
      await dbHelper.insertRepositoriesIsolate(gitReposApiData);
      gitReposLocal = await dbHelper.getRepositories();
      if (gitReposLocal.isEmpty) {
        emit(const GitRepoError("No Result Found for Today"));
      } else {
        emit(GitRepoLoaded(gitReposLocal));
      }
    } catch (e) {
      emit(const GitRepoError("Unable to Load Results"));
    }
  }
}

class ComputeApiHelper {
  final String repoDate;
  ComputeApiHelper({required this.repoDate});
}

Future<List<GitRepo>> _computeApiAndDb(
    ComputeApiHelper computeApiAndDbHelper) async {
  final repoData =
      await GitRepoRepository.getRepos(computeApiAndDbHelper.repoDate);
  return repoData;
}
