import 'dart:async';
import 'package:barback/barback.dart';

class RemoveTransformer extends Transformer {
  final BarbackSettings _settings;

  RemoveTransformer.asPlugin(this._settings);

  @override
  Future<Object> apply(Transform transform) async {
    if (this._settings.mode.name == 'release') {
      final Pattern removePattern = new RegExp(r'^.*(?:remove:line|remove:start(?:.|\n)*?remove:end).*$\n?', multiLine: true);
      final String content = await transform.primaryInput.readAsString();
      final AssetId id = transform.primaryInput.id;
      final String newContent = content.replaceAll(removePattern, '');

      transform.addOutput(new Asset.fromString(id, newContent));
    }
  }
}
