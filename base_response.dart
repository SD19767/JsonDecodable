class BaseResponse<T extends JsonDecodable<T>> {
  final List<T> result;

  BaseResponse({required this.result});

  // Factory method to decode from JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final dynamic jsonData = json['result'];

    if (jsonData is Map<String, dynamic>) {
      // Decoding a single object if 'result' is a Map
      final T decodedResult = fromJsonT(jsonData);
      return BaseResponse(result: [decodedResult]);
    } else if (jsonData is List) {
      // Decoding a list of objects if 'result' is a List
      final List<T> decodedResult = jsonData
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList();
      return BaseResponse(result: decodedResult);
    } else {
      throw Exception('Unexpected JSON format for "result": ${jsonData.runtimeType}');
    }
  }
}
