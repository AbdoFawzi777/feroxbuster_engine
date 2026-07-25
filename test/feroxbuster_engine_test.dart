import 'package:flutter_test/flutter_test.dart';
import 'package:feroxbuster_engine/feroxbuster_engine.dart';

void main() {
  test('FeroxbusterEngine initialization test', () async {
    final engine = FeroxbusterEngine();
    await engine.initialize();
    expect(engine.isInitialized, true);
  });
}
