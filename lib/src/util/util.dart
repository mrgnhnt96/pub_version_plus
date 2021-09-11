import 'dart:io';

import 'package:path/path.dart' as p;

const appName = 'pubversion';
const appDescription = 'A tool to develop Dart & Flutter projects.';

/// The path to the root directory of the SDK.
final String _sdkDir = (() {
  // The Dart executable is in "/path/to/sdk/bin/dart", so two levels up is
  // "/path/to/sdk".
  var aboveExecutable = p.dirname(p.dirname(Platform.resolvedExecutable));
  assert(FileSystemEntity.isFileSync(p.join(aboveExecutable, 'version')));
  return aboveExecutable;
})();

final String dartPath = p.join(_sdkDir, 'bin', 'dart');
final String pubSnapshot =
    p.join(_sdkDir, 'bin', 'snapshots', 'pub.dart.snapshot');
final String pubPath =
    p.join(_sdkDir, 'bin', Platform.isWindows ? 'pub.bat' : 'pub');
