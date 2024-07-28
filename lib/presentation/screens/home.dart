import 'package:ailoitte_task/bloc/git_repo/git_repo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GitRepoBloc>(context).add(const FetchGitRepos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Repos'),
      ),
      body: BlocConsumer<GitRepoBloc, GitRepoState>(
        listener: (context, state) {
          if (state is GitRepoLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Results Updated'),
              ),
            );
          } else if (state is GitRepoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('No Resutls Found'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GitRepoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GitRepoLoaded) {
            final repoList = state.gitRepos;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GitRepoBloc>().add(const FetchGitReposForToday());
              },
              child: ListView.builder(
                itemCount: repoList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(repoList[index].name!),
                      subtitle: Text(repoList[index].description ?? "NA"),
                    ),
                  );
                },
              ),
            );
          } else if (state is GitRepoError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
