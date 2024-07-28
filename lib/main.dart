import 'package:ailoitte_task/bloc/git_repo/git_repo_bloc.dart';
import 'package:ailoitte_task/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GitRepoBloc>(
          create: (BuildContext context) => GitRepoBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            color: Colors.blue,
          ),
        ),
        home: const Home(),
      ),
    );
  }
}
