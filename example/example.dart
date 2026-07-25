import 'package:feroxbuster_engine/feroxbuster_engine.dart';

void main() async {
  final engine = FeroxbusterEngine();
  await engine.initialize();
  print('FeroxbusterEngine is ready for tactical operations.');
}
