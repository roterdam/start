library start_test;

import 'dart:async';
import 'dart:io';

import 'package:unittest/unittest.dart';

final TESTS = [
                'class.dart',
                'gcd.dart',
                'hanoifibfac.dart',
                'link.dart',
                'mmm.dart',
                'prime.dart',
                'rational.dart',
                'regslarge.dart',
                'sieve.dart',
                'sort.dart',
                'struct.dart',
                ];

Future<List<String>> run(String vm, String interp, String dir, String test) {
  final dart = Process.run(vm, ['--checked', '$dir/$test'])
      .then((r) => r.stdout);
  final start = Process.run(vm, ['--checked', interp, '$dir/$test'])
      .then((r) => r.exitCode != 0
        ? fail('$test failed on:\n${r.stderr}')
        : r.stdout);

  return Future.wait([dart, start]);
}

void main() {
  final vm = Platform.executable;
  final script = Platform.script.path;
  String path = new File(script).parent.parent.path;
  runTests(vm, '$path');
}

void runTests(String vm, String path) {
  final interp = '$path/bin/start.dart';
  for (final name in TESTS) {
   test('typed $name', () {
     final check = expectAsync((results) {
       final dart = results[0];
       final start = results[1];
       expect(start, equals(dart));
     });
     run(vm, interp, '$path/examples', name)
       .then(check);
   });
  }

  for (final name in TESTS) {
   test('untyped $name', () {
     final check = expectAsync((results) {
       final dart = results[0];
       final start = results[1];
       expect(start, equals(dart));
     });
     run(vm, interp, '$path/untyped', name)
       .then(check);
   });
  }
}
