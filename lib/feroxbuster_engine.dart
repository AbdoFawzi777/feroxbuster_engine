import 'dart:async';
import 'package:http/http.dart' as http;

class FeroxbusterEngine {
  static final FeroxbusterEngine _instance = FeroxbusterEngine._internal();
  factory FeroxbusterEngine() => _instance;
  FeroxbusterEngine._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
  }

  Future<FeroxResult> scan(String targetUrl, {List<String>? wordlist}) async {
    final list = wordlist ?? ['admin', 'login'];
    final List<DiscoveryMatch> found = [];
    final client = http.Client();
    try {
      for (final path in list) {
        final url = targetUrl.endsWith('/') ? targetUrl + path : '$targetUrl/$path';
        try {
          final resp = await client.get(Uri.parse(url)).timeout(const Duration(seconds: 4));
          if (resp.statusCode != 404) {
            found.add(DiscoveryMatch(path: path, statusCode: resp.statusCode, size: resp.body.length, type: resp.headers['content-type'] ?? 'unknown'));
          }
        } catch (_) {}
      }
    } finally {
      client.close();
    }
    return FeroxResult(target: targetUrl, found: found, duration: const Duration(seconds: 1));
  }
}

class DiscoveryMatch {
  final String path, type;
  final int statusCode, size;
  DiscoveryMatch({required this.path, required this.statusCode, required this.size, required this.type});
}

class FeroxResult {
  final String target;
  final List<DiscoveryMatch> found;
  final Duration duration;
  FeroxResult({required this.target, required this.found, required this.duration});
}
