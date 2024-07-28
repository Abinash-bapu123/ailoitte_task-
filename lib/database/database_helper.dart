import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:ailoitte_task/data/models/git_repo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() => _instance;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'git_repo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE git_repo(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRepositories(List<GitRepo> gitRepos) async {
    final db = await database;
    Batch batch = db.batch();
    for (var gitRepo in gitRepos) {
      batch.insert('git_repo', gitRepo.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertRepositoriesIsolate(List<GitRepo> gitRepos) async {
    final db = await database;
    Batch batch = db.batch();
    ComputeDbHelper computeDbHelper =
        ComputeDbHelper(batch: batch, gitRepos: gitRepos);
    await compute(_insertIsolate, computeDbHelper);
    await batch.commit(noResult: true);
  }

  Future<List<GitRepo>> getRepositories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('git_repo');
    return List.generate(maps.length, (i) {
      return GitRepo.fromJson(maps[i]);
    });
  }

  Future<void> clearRepositories() async {
    final db = await database;
    await db.delete('git_repo');
  }
}

class ComputeDbHelper {
  final Batch batch;
  final List<GitRepo> gitRepos;
  ComputeDbHelper({required this.batch, required this.gitRepos});
}

void _insertIsolate(ComputeDbHelper computeHelper) async {
  for (var gitRepo in computeHelper.gitRepos) {
    computeHelper.batch.insert('git_repo', gitRepo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
