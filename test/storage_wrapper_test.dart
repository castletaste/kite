import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await Storage.init();
  });

  group('Storage categories', () {
    test('get/set categories json and last modified', () async {
      expect(Storage.getCategoriesJson(), isNull);
      expect(Storage.getCategoriesLastModified(), isNull);

      await Storage.setCategoriesJson('jsonData');
      expect(Storage.getCategoriesJson(), 'jsonData');

      await Storage.setCategoriesLastModified('mod');
      expect(Storage.getCategoriesLastModified(), 'mod');
    });
  });

  group('Storage news', () {
    test('get/set news json and last modified', () async {
      const cat = 'tech.json';
      expect(Storage.getNewsJson(cat), isNull);
      expect(Storage.getNewsLastModified(cat), isNull);

      await Storage.setNewsJson(cat, 'news');
      expect(Storage.getNewsJson(cat), 'news');

      await Storage.setNewsLastModified(cat, 'lm');
      expect(Storage.getNewsLastModified(cat), 'lm');
    });
  });

  group('Storage read clusters', () {
    test('get/set read clusters', () async {
      expect(Storage.getReadClusters(), isEmpty);

      await Storage.setReadClusters({'a', 'b'});
      expect(Storage.getReadClusters(), containsAll(['a', 'b']));
    });
  });

  group('Storage last selected category', () {
    test('get/set last selected category', () async {
      expect(Storage.getLastSelectedCategory(), isNull);

      await Storage.setLastSelectedCategory('c.json');
      expect(Storage.getLastSelectedCategory(), 'c.json');
    });
  });
}
