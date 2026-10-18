/// Keeps failed API responses safe for callers that read `data['message']`.
Map<String, dynamic> apiErrorData(dynamic data, {required String fallbackMessage}) {
  final normalized = <String, dynamic>{};
  if (data is Map) {
    for (final entry in data.entries) {
      if (entry.key is String) {
        normalized[entry.key as String] = entry.value;
      }
    }
  }
  final message = normalized['message'];
  if (message is! String || message.trim().isEmpty) {
    normalized['message'] = fallbackMessage;
  }
  return normalized;
}
