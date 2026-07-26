import 'dart:async';
import 'package:http/http.dart' as http;
import 'models.dart';

class FeroxbusterEngine {
  static final FeroxbusterEngine _instance = FeroxbusterEngine._internal();
  factory FeroxbusterEngine() => _instance;
  FeroxbusterEngine._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
  }

  static const List<String> _wordlist = [
    'admin', 'login', 'dashboard', 'panel', 'api', 'v1', 'v2',
    'user', 'users', 'account', 'auth', 'logout', 'register',
    'config', 'settings', 'setup', 'install', 'update',
    'backup', 'restore', 'export', 'import', 'data', 'db',
    'uploads', 'files', 'images', 'media', 'assets', 'static',
    'js', 'css', 'fonts', 'icons', 'img', 'src', 'dist', 'build',
    'includes', 'inc', 'lib', 'libs', 'vendor', 'modules', 'plugins',
    'test', 'tests', 'dev', 'staging', 'temp', 'tmp', 'cache',
    'logs', 'log', 'error', 'debug', 'info', 'trace',
    '.git', '.svn', '.env', '.htaccess', '.htpasswd',
    'robots.txt', 'sitemap.xml', 'phpinfo.php', 'server-status',
    'search', 'find', 'query', 'report', 'reports',
    'swagger', 'graphql', 'rest', 'soap', 'wsdl',
    'health', 'status', 'ping', 'metrics', 'actuator',
    'private', 'public', 'protected', 'secure', 'hidden', 'secret',
    'console', 'terminal', 'shell', 'cmd', 'exec',
    'download', 'downloads', 'upload', 'ajax', 'callback',
    'phpmyadmin', 'adminer', 'pma', 'mysql', 'postgres',
  ];

  Future<FeroxResult> scan(String url, {
    List<String>? wordlist,
    int concurrency = 20,
    bool autoRecurse = true,
    int maxDepth = 3,
    int timeout = 4,
  }) async {
    final startTime = DateTime.now();
    final normalizedUrl = url.startsWith('http') ? url : 'http://$url';
    final base = normalizedUrl.endsWith('/') ? normalizedUrl : '$normalizedUrl/';
    final words = wordlist ?? _wordlist;
    final allResults = <FeroxEntry>[];
    final scannedDirs = <String>{};
    int totalScanned = 0;

    // Initial scan
    final queue = <String>[base];
    int depth = 0;

    while (queue.isNotEmpty && depth < maxDepth) {
      final currentUrl = queue.removeAt(0);
      if (scannedDirs.contains(currentUrl)) continue;
      scannedDirs.add(currentUrl);

      final levelResults = await _scanLevel(currentUrl, words, concurrency, timeout);
      totalScanned += words.length;
      allResults.addAll(levelResults);

      if (autoRecurse) {
        final directories = levelResults.where((r) => r.isDirectory).toList();
        for (final dir in directories.take(5)) {
          final newUrl = '$currentUrl${dir.path}/';
          if (!scannedDirs.contains(newUrl)) queue.add(newUrl);
        }
      }
      depth++;
    }

    return FeroxResult(
      totalScanned: totalScanned,
      results: allResults,
      scanDuration: DateTime.now().difference(startTime),
      timestamp: DateTime.now(),
    );
  }

  Future<List<FeroxEntry>> _scanLevel(
    String baseUrl, List<String> words, int concurrency, int timeout
  ) async {
    final results = <FeroxEntry>[];
    for (int i = 0; i < words.length; i += concurrency) {
      final chunk = words.skip(i).take(concurrency).toList();
      final futures = chunk.map((w) => _probe(baseUrl, w, timeout)).toList();
      final chunkResults = await Future.wait(futures);
      for (final r in chunkResults) {
        if (r != null) results.add(r);
      }
    }
    return results;
  }

  Future<FeroxEntry?> _probe(String base, String word, int timeout) async {
    try {
      final response = await http.get(
        Uri.parse('$base$word'),
        headers: {'User-Agent': 'feroxbuster/2.10.4 (RedOps)'},
      ).timeout(Duration(seconds: timeout));

      if (response.statusCode == 404) return null;

      final contentType = response.headers['content-type'] ?? 'unknown';
      final size = response.contentLength ?? response.body.length;
      final isDirectory = response.statusCode == 301 ||
          response.statusCode == 302 ||
          (contentType.contains('text/html') && !word.contains('.'));

      return FeroxEntry(
        path: word,
        statusCode: response.statusCode,
        contentType: contentType,
        size: size,
        wordCount: response.body.split(RegExp(r'\s+')).length,
        lineCount: response.body.split('\n').length,
        isDirectory: isDirectory,
      );
    } catch (_) {
      return null;
    }
  }
}
