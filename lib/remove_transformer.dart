import 'dart:async';
import 'package:barback/barback.dart';

class RemoveTransformer extends Transformer {
  final BarbackSettings _settings;

  RemoveTransformer.asPlugin(this._settings);

  @override
  isPrimary(AssetId id) {
    return this._settings.mode.name == 'release';
  }

  @override
  Future<Object> apply(Transform transform) async {
    try {
      final String content = await transform.primaryInput.readAsString();
      final Pattern removePattern = new RegExp(r'^.*(?:remove:line|remove:start(?:.|\n)*?remove:end).*$\n?', multiLine: true);
      final AssetId id = transform.primaryInput.id;
      final String newContent = content.replaceAll(removePattern, '');

      transform.addOutput(new Asset.fromString(id, newContent));
    }
    on FormatException {
      // skip format exceptions
      // this most likely means the file has an invalid format such as an image or font
    }
  }
}
