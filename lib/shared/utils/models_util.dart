List<T> castJsonPropertyToListToList<T>(
  Map<String, dynamic> json,
  String property,
) {
  final jsonPropertyValue = json[property];
  return jsonPropertyValue == null ? null : jsonPropertyValue.cast<T>();
}
