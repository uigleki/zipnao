import 'package:flutter_test/flutter_test.dart';
import 'package:zipnao/utils/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccess returns true', () {
        const result = Success<int, String>(42);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
      });

      test('valueOrNull returns value', () {
        const result = Success<int, String>(42);
        expect(result.valueOrNull, 42);
      });

      test('errorOrNull returns null', () {
        const result = Success<int, String>(42);
        expect(result.errorOrNull, isNull);
      });

      test('when calls success callback', () {
        const result = Success<int, String>(42);
        final output = result.when(
          success: (v) => 'value: $v',
          failure: (e) => 'error: $e',
        );
        expect(output, 'value: 42');
      });
    });

    group('Failure', () {
      test('isFailure returns true', () {
        const result = Failure<int, String>('error');
        expect(result.isFailure, isTrue);
        expect(result.isSuccess, isFalse);
      });

      test('errorOrNull returns error', () {
        const result = Failure<int, String>('error');
        expect(result.errorOrNull, 'error');
      });

      test('valueOrNull returns null', () {
        const result = Failure<int, String>('error');
        expect(result.valueOrNull, isNull);
      });

      test('when calls failure callback', () {
        const result = Failure<int, String>('error');
        final output = result.when(
          success: (v) => 'value: $v',
          failure: (e) => 'error: $e',
        );
        expect(output, 'error: error');
      });
    });
  });
}
