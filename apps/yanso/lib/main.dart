import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  runApp(
    // ProviderScope is the root of Riverpod's dependency tree.
    // All providers are scoped within this widget.
    const ProviderScope(child: YansoApp()),
  );
}
