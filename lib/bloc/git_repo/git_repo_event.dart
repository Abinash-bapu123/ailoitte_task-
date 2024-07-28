part of 'git_repo_bloc.dart';

sealed class GitRepoEvent extends Equatable {
  const GitRepoEvent();

  @override
  List<Object> get props => [];
}

class FetchGitRepos extends GitRepoEvent {
  const FetchGitRepos();
}

class FetchGitReposForToday extends GitRepoEvent {
  const FetchGitReposForToday();
}
