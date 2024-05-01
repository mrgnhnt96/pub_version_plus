import 'package:pub_version_plus/src/command/version_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

class BuildCommand extends VersionCommand {
  BuildCommand(String path, {required super.fs}) : super(path);

  @override
  PubVersion get type => PubVersion.build;

  @override
  String get description => PubVersion.build.description;

  @override
  String get name => PubVersion.build.name;
}
