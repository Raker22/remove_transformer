@TestOn('vm')
import 'dart:io';

import 'package:barback/barback.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:remove_transformer/remove_transformer.dart';

import 'transformer_mocks.dart';

void main() {
  final Transformer releaseTransformer = new RemoveTransformer.asPlugin(
    new BarbackSettings(<dynamic, dynamic>{}, BarbackMode.RELEASE)
  );
  final Transformer debugTransformer = new RemoveTransformer.asPlugin(
    new BarbackSettings(<dynamic, dynamic>{}, BarbackMode.DEBUG)
  );
  final String replaceExpected = '''Debug+Release
Debug+Release
Debug+Release
''';

  // see https://github.com/Workiva/dart_to_js_script_rewriter/tree/master/test for example
  group('apply()', () {
    test('replaces lines marked with replace:line', () async {
      final String testFile = 'test/test_data/replace_line.txt';
      final AssetId assetId = new AssetId('testid', testFile);
      final MockAsset inputFile = new MockAsset();
      final MockTransform mockTransform = new MockTransform();

      when(inputFile.id).thenReturn(assetId);
      when(inputFile.readAsString()).thenReturn(
        new File.fromUri(Uri.parse(testFile)).readAsString()
      );

      when(mockTransform.primaryInput).thenReturn(inputFile);
      when(mockTransform.readInputAsString(assetId)).thenAnswer((_) {
        return new File.fromUri(Uri.parse(testFile)).readAsString();
      });

      await releaseTransformer.apply(mockTransform);

      final Asset fileAsset = verify(mockTransform.addOutput(captureAny)).captured.first;
      final String transformedFile = await fileAsset.readAsString();

      expect(transformedFile, equals(replaceExpected));
    });

    test('replaces blocks marked with replace:start / replace:end', () async {
      final String testFile = 'test/test_data/replace_block.txt';
      final AssetId assetId = new AssetId('testid', testFile);
      final MockAsset inputFile = new MockAsset();
      final MockTransform mockTransform = new MockTransform();

      when(inputFile.id).thenReturn(assetId);
      when(inputFile.readAsString()).thenReturn(
        new File.fromUri(Uri.parse(testFile)).readAsString()
      );

      when(mockTransform.primaryInput).thenReturn(inputFile);
      when(mockTransform.readInputAsString(assetId)).thenAnswer((_) {
        return new File.fromUri(Uri.parse(testFile)).readAsString();
      });

      await releaseTransformer.apply(mockTransform);

      final Asset fileAsset = verify(mockTransform.addOutput(captureAny)).captured.first;
      final String transformedFile = await fileAsset.readAsString();

      expect(transformedFile, equals(replaceExpected));
    });

    test('does not modify the file if it isn\'t UTF-8 encoded', () async {
      final String testFile = 'test/test_data/test_image.png';
      final AssetId assetId = new AssetId('testid', testFile);
      final MockAsset inputFile = new MockAsset();
      final MockTransform mockTransform = new MockTransform();

      when(inputFile.id).thenReturn(assetId);
      when(inputFile.readAsString()).thenThrow(const FormatException());

      when(mockTransform.primaryInput).thenReturn(inputFile);
      when(mockTransform.readInputAsString(assetId)).thenAnswer((_) {
        return const FormatException();
      });

      await debugTransformer.apply(mockTransform);

      verifyNever(mockTransform.addOutput(captureAny));
    });
  });

  group('isPrimary()', () {
    test('returns true when in \'release\' mode', () {
      final AssetId assetId = new AssetId('testid', '');

      expect(releaseTransformer.isPrimary(assetId), isTrue);
    });

    test('returns false when not in \'release\' mode', () async {
      final AssetId assetId = new AssetId('testid', '');

      expect(debugTransformer.isPrimary(assetId), isFalse);
    });
  });
}
