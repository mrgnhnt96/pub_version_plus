import 'package:pub_version_plus/src/command/version_command.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';

class PatchCommand extends VersionCommand {
  PatchCommand(String path, {required super.fs}) : super(path);

  @override
  PubVersion get type => PubVersion.patch;

  @override
  String get description => PubVersion.patch.description;

  @override
  String get name => PubVersion.patch.name;
}
