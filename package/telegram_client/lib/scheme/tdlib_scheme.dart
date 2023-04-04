// ignore_for_file: empty_catches

extension RemoveValueNullMapExtensions on Map {
  Map removeValueNull() {
    try {
      forEach((key, value) {
        try {
          if (value == null) {
            remove(key);
          }
        } catch (e) {}
      });
      return this;
    } catch (e) {
      return this;
    }
  }
}
