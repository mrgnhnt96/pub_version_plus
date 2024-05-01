import 'package:pub_version_plus/src/util/exceptions.dart';
import 'package:pub_version_plus/src/util/pub_version.dart';
import 'package:pub_version_plus/src/util/pubspec_handler.dart';
import 'package:test/test.dart';

import '../../util/pubspec.dart';

void main() {
  final pubspecHasVersion = PubspecHandler(pubspecWithVersion);
  final pubspecHasNoVersion = PubspecHandler(pubspecWithNoVersion);

  test('should fail when not initialized', () {
    final handler = PubspecHandler(pubspecWithVersion);
    expect(() => handler.pubspec, throwsA(isA<HasNotInitiatedException>()));
    expect(() => handler.version, throwsA(isA<HasNotInitiatedException>()));
  });

  group('Has Version,', () {
    final additionalHasBuildSetUp =
        (PubspecHandler handler) => handler.reset(hasBuild: true);
    final additionalNoBuildSetUp =
        (PubspecHandler handler) => handler.reset(hasBuild: true);

    final tearDown = (PubspecHandler handler) => handler.reset();

    PubspecHandlerTestUtil.runTests(
      type: PubVersion.major,
      initializer: () => pubspecHasVersion,
      additionalHasBuildSetUp: additionalHasBuildSetUp,
      additionalNoBuildSetUp: additionalNoBuildSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.minor,
      initializer: () => pubspecHasVersion,
      additionalHasBuildSetUp: additionalHasBuildSetUp,
      additionalNoBuildSetUp: additionalNoBuildSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.patch,
      initializer: () => pubspecHasVersion,
      additionalHasBuildSetUp: additionalHasBuildSetUp,
      additionalNoBuildSetUp: additionalNoBuildSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.build,
      initializer: () => pubspecHasVersion,
      additionalHasBuildSetUp: additionalHasBuildSetUp,
      additionalNoBuildSetUp: additionalNoBuildSetUp,
      additionalTearDown: tearDown,
    );
  });

  group('Has No Version,', () {
    final additionalSetUp = (PubspecHandler handler) => handler.removeVersion();
    final tearDown = (PubspecHandler handler) => handler.removeVersion();

    PubspecHandlerTestUtil.runTests(
      type: PubVersion.major,
      initializer: () => pubspecHasNoVersion,
      additionalHasBuildSetUp: additionalSetUp,
      additionalNoBuildSetUp: additionalSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.minor,
      initializer: () => pubspecHasNoVersion,
      additionalHasBuildSetUp: additionalSetUp,
      additionalNoBuildSetUp: additionalSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.patch,
      initializer: () => pubspecHasNoVersion,
      additionalHasBuildSetUp: additionalSetUp,
      additionalNoBuildSetUp: additionalSetUp,
      additionalTearDown: tearDown,
    );
    PubspecHandlerTestUtil.runTests(
      type: PubVersion.build,
      initializer: () => pubspecHasNoVersion,
      additionalHasBuildSetUp: additionalSetUp,
      additionalNoBuildSetUp: additionalSetUp,
      additionalTearDown: tearDown,
    );
  });
}

typedef Initializer = PubspecHandler Function();
typedef SetUp = Future<void> Function(PubspecHandler handler);

// ignore: avoid_classes_with_only_static_members
class PubspecHandlerTestUtil {
  static void runTests({
    required PubVersion type,
    required Initializer initializer,
    SetUp? additionalHasBuildSetUp,
    SetUp? additionalNoBuildSetUp,
    SetUp? additionalTearDown,
  }) {
    late PubspecHandler handler;

    setUp(() async {
      handler = initializer();
      await handler.initialize();
      if (additionalHasBuildSetUp != null) {
        await additionalHasBuildSetUp(handler);
      }
    });

    tearDownAll(() async {
      if (additionalTearDown == null) return;
      await additionalTearDown(handler);
    });

    group('$type has build', () {
      setUp(() async {
        await handler.reset(hasBuild: true);
      });

      test('should return new version ${type.newVersion(hasBuild: true)}',
          () async {
        final version = handler.version;
        await handler.nextVersion(type);
        final updatedVersion = handler.version;

        expect(version, isNot(equals(updatedVersion)));
        expect('$updatedVersion', equals(type.newVersion(hasBuild: false)));
      });
    });

    group('$type does not have build', () {
      setUp(() async {
        await handler.reset();
      });

      test('should return new version  ${type.newVersion()}', () async {
        final version = handler.version;
        await handler.nextVersion(type);
        final updatedVersion = handler.version;

        expect(version, isNot(equals(updatedVersion)));
        expect('$updatedVersion', equals(type.newVersion()));
      });
    });
  }

  static void runTestsWithNoVersion({
    required PubVersion type,
    required Initializer initializer,
  }) {
    late PubspecHandler handler;

    setUp(() async {
      handler = initializer();
      await handler.initialize();
      await handler.removeVersion();
    });

    group('$type has build', () {
      setUp(() async {
        await handler.reset(hasBuild: true);
      });
      tearDownAll(() async {
        await handler.reset(hasBuild: true);
      });

      test('should return new version  ${type.newVersion(hasBuild: true)}',
          () async {
        final version = handler.version;
        await handler.nextVersion(type);
        final updatedVersion = handler.version;

        expect(version, isNot(equals(updatedVersion)));
        expect('$updatedVersion', equals(type.newVersion(hasBuild: true)));
      });
    });

    group('$type does not have build', () {
      setUp(() async {
        await handler.reset();
      });

      tearDown(() async {
        await handler.reset();
      });

      test('should return new version  ${type.newVersion()}', () async {
        final version = handler.version;
        await handler.nextVersion(type);
        final updatedVersion = handler.version;

        expect(version, isNot(equals(updatedVersion)));
        expect('$updatedVersion', equals(type.newVersion()));
      });
    });
  }
}

extension on PubVersion {
  String newVersion({bool hasBuild = false}) {
    switch (this) {
      case PubVersion.major:
        if (hasBuild) return '1.0.0+0';
        return '1.0.0';
      case PubVersion.minor:
        if (hasBuild) return '0.1.0+0';
        return '0.1.0';
      case PubVersion.patch:
        if (hasBuild) return '0.0.1+0';
        return '0.0.1';
      case PubVersion.build:
        return '0.0.0+1';
    }
  }
}
