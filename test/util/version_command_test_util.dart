import 'package:pub_version_plus/src/command/version_commmand.dart';
import 'package:pub_version_plus/src/util/enum.dart';
import 'package:test/test.dart';

typedef Initializer<T extends VersionCommand> = T Function();
// typedef MethodCallback<R, T> = R Function(T);

// ignore: avoid_classes_with_only_static_members
class VersionCommandTestUtil {
  static void runTests<T extends VersionCommand>({
    // required String methodName,
    required PubVersion type,
    required Initializer<T> initializer,
    // required MethodCallback<R, T> testMethod,
  }) {
    group('getters', () {
      late T command;

      setUp(() {
        command = initializer();
      });

      tearDown(() async {
        await command.handler.reset();
      });

      test('#type should return $type', () {
        expect(command.type, type);
      });

      test('#description should return $type\'s description', () {
        expect(command.type.description, type.description);
      });

      test('#name should return $type\'s name', () {
        expect(command.name, type.name);
      });
    });
  }
}
