import 'package:flutter_test/flutter_test.dart';
import 'package:tasker/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TaskSummaryViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
