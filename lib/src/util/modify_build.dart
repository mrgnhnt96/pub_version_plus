enum ModifyBuild {
  increment,
  reset,
  remove,
  none;

  bool get isIncrement => this == ModifyBuild.increment;
  bool get isReset => this == ModifyBuild.reset;
  bool get isRemove => this == ModifyBuild.remove;

  String get description {
    switch (this) {
      case ModifyBuild.increment:
        return 'Increment the build number, if it exists.';
      case ModifyBuild.reset:
        return 'Reset the build number to 0.';
      case ModifyBuild.remove:
        return 'Remove the build number.';
      case ModifyBuild.none:
        return 'Do nothing to the build number, if it exists.';
    }
  }
}
