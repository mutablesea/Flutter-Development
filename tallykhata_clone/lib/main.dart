import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

void main() => runApp(const TallyApp());

class TallyApp extends StatelessWidget {
  const TallyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TallyKhata Clone',
    theme: appTheme(),
    initialRoute: Routes.splash,
    routes: appRoutes,
  );
}
