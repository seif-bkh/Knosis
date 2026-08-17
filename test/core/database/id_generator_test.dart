import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/core/database/id_generator.dart';

final RegExp _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  group('IdGenerator', () {
    test('produces a well formed version 4 UUID', () {
      expect(IdGenerator.uuidV4(), matches(_uuidV4));
    });

    test('does not repeat itself', () {
      final Set<String> ids = <String>{};
      for (int i = 0; i < 2000; i++) {
        ids.add(IdGenerator.uuidV4());
      }

      expect(ids, hasLength(2000));
    });
  });
}
