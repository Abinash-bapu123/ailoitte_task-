part of 'git_repo_bloc.dart';

sealed class GitRepoState extends Equatable {
  const GitRepoState();

  @override
  List<Object> get props => [];
}

final class GitRepoInitial extends GitRepoState {}

class GitRepoLoading extends GitRepoState {}

class GitRepoLoaded extends GitRepoState {
  final List<GitRepo> gitRepos;

  const GitRepoLoaded(this.gitRepos);

  @override
  List<Object> get props => [gitRepos];
}

class GitRepoError extends GitRepoState {
  final String message;

  const GitRepoError(this.message);

  @override
  List<Object> get props => [message];
}
