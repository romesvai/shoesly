extension StringX on String? {
  String capitalize() {
    if (this == null || this?.isEmpty == true) {
      return '';
    }
    return this![0].toUpperCase() + this!.substring(1);
  }
}
