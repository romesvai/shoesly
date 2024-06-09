extension ListX<E> on List<E>? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty == true);
}
