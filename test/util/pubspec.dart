import 'package:file/file.dart';

const pubspecWithVersion = Pubspec(
  path: 'test/util/version_pubspec.yaml',
  content: '''
name: pub_version_plus_test
version: 0.0.0
''',
);

const pubspecWithNoVersion = Pubspec(
  path: 'test/util/no_version_pubspec.yaml',
  content: '''
name: pub_version_plus_test

environment:
  sdk: ">=2.13.0 <3.0.0"
''',
);

const pubspecWithPreRelease = Pubspec(
  path: 'test/util/pre_release_pubspec.yaml',
  content: '''
name: pub_version_plus_test
version: 0.0.3-beta

environment:
  sdk: ">=2.13.0 <3.0.0"
''',
);

const pubspecWithPreReleaseAndBuild = Pubspec(
  path: 'test/util/no_version_pubspec.yaml',
  content: '''
name: pub_version_plus_test
version: 0.0.0-beta+0

environment:
  sdk: ">=2.13.0 <3.0.0"
''',
);

const pubspecWithNoName = Pubspec(
  path: 'test/util/no_name_pubspec.yaml',
  content: '',
);

class Pubspec {
  const Pubspec({
    required this.path,
    required this.content,
  });

  final String path;
  final String content;

  Future<void> write(FileSystem fs) async {
    await fs.file(path).create(recursive: true);

    await fs.file(path).writeAsString(content);
  }
}
