import 'package:io/io.dart';

enum VersionMessage {
  success,
  couldNotUpdateVersion,
}

extension VersionMessageX on VersionMessage {
  int get code {
    switch (this) {
      case VersionMessage.success:
        return ExitCode.success.code;
      case VersionMessage.couldNotUpdateVersion:
        return ExitCode.osFile.code;
    }
  }

  String get message {
    switch (this) {
      case VersionMessage.success:
        return 'Success';
      case VersionMessage.couldNotUpdateVersion:
        return 'Could not update the version';
    }
  }
}
