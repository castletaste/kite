import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kite/providers/router_provider.dart';
import 'package:kite/services/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp.router(
      title: 'Kite',
      routerConfig: ref.watch(routerProvider),
    );
  }
}
