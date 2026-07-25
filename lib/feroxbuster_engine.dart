/// ⚡ Feroxbuster Engine - Fast directory scanning for Flutter
library feroxbuster_engine;

import 'package:http/http.dart' as http;

class FeroxbusterEngine {
  static final FeroxbusterEngine _instance = FeroxbusterEngine._internal();
  factory FeroxbusterEngine() => _instance;
  FeroxbusterEngine._internal();

  bool _initialized = false;

  static const List<String> _defaultWordlist = [
    'admin', 'login', 'wp-admin', 'backup', 'config', 'api',
    'uploads', 'files', '.git', '.env', 'phpmyadmin', 'test',
    'dev', 'staging', 'robots.txt', 'sitemap.xml', 'dashboard',
    'manager', 'control', 'adminer', 'cpanel', 'hidden', 'secret',
    'private', 'confidential', 'restricted', 'backup.zip', 'backup.tar',
  ];

  /// 🚀 تهيئة المحرك
  Future<void> initialize() async {
    _initialized = true;
  }

  /// 🔍 فحص الدلائل السريع
  Future<FeroxbusterResult> scan(String target, {List<String>? wordlist}) async {
    final wordlistToUse = wordlist ?? _defaultWordlist;
    final results = <DirResult>[];

    for (final word in wordlistToUse) {
      try {
        final url = '$target/$word';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 404 && response.statusCode != 403) {
          results.add(DirResult(
            path: word,
            statusCode: response.statusCode,
            size: response.body.length,
            contentType: response.headers['content-type'] ?? 'unknown',
          ));
        }
      } catch (_) {}
    }

    return FeroxbusterResult(
      results: results,
      totalScanned: wordlistToUse.length,
    );
  }

  bool get isInitialized => _initialized;
}

class DirResult {
  final String path;
  final int statusCode;
  final int size;
  final String contentType;
  
  DirResult({
    required this.path,
    required this.statusCode,
    required this.size,
    required this.contentType,
  });
}

class FeroxbusterResult {
  final List<DirResult> results;
  final int totalScanned;
  FeroxbusterResult({
    required this.results,
    required this.totalScanned,
  });
}
