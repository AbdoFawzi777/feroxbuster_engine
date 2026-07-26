class FeroxEntry {
  final String path;
  final int statusCode;
  final String contentType;
  final int size;
  final int wordCount;
  final int lineCount;
  final bool isDirectory;

  const FeroxEntry({
    required this.path,
    required this.statusCode,
    this.contentType = 'unknown',
    this.size = 0,
    this.wordCount = 0,
    this.lineCount = 0,
    this.isDirectory = false,
  });

  Map<String, dynamic> toJson() => {
    'path': path,
    'statusCode': statusCode,
    'contentType': contentType,
    'size': size,
    'wordCount': wordCount,
    'lineCount': lineCount,
    'isDirectory': isDirectory,
  };
}

class FeroxResult {
  final int totalScanned;
  final List<FeroxEntry> results;
  final Duration scanDuration;
  final DateTime timestamp;

  const FeroxResult({
    required this.totalScanned,
    required this.results,
    required this.scanDuration,
    required this.timestamp,
  });

  List<FeroxEntry> get directories => results.where((r) => r.isDirectory).toList();
  List<FeroxEntry> get files => results.where((r) => !r.isDirectory).toList();
}
