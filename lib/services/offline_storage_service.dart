import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/offline/offline_database.dart';
import '../models/offline/offline_analysis.dart';

class OfflineStorageService {
  static const String _customersFileName = 'customers.json';
  static const String _analysisFileName = 'analysis.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final offlineDir = Directory('${directory.path}/offline');
    if (!await offlineDir.exists()) {
      await offlineDir.create(recursive: true);
    }
    return offlineDir.path;
  }

  Future<File> _getFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<OfflineDatabase?> loadCustomers() async {
    try {
      final file = await _getFile(_customersFileName);
      if (!await file.exists()) {
        return null;
      }
      final contents = await file.readAsString();
      return OfflineDatabase.fromJsonString(contents);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveCustomers(OfflineDatabase database) async {
    final file = await _getFile(_customersFileName);
    await file.writeAsString(database.toJsonString());
  }

  Future<OfflineAnalysisDatabase?> loadAnalysis() async {
    try {
      final file = await _getFile(_analysisFileName);
      if (!await file.exists()) {
        return null;
      }
      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return OfflineAnalysisDatabase.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAnalysis(OfflineAnalysisDatabase analysis) async {
    final file = await _getFile(_analysisFileName);
    await file.writeAsString(jsonEncode(analysis.toJson()));
  }

  Future<void> deleteAll() async {
    try {
      final customersFile = await _getFile(_customersFileName);
      final analysisFile = await _getFile(_analysisFileName);
      if (await customersFile.exists()) {
        await customersFile.delete();
      }
      if (await analysisFile.exists()) {
        await analysisFile.delete();
      }
    } catch (e) {
      // Ignore errors on delete
    }
  }
}