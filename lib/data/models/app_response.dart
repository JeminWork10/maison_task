class AppResponse {
  final bool? success;
  final String? message;
  final dynamic data;
  final String? errorCode;
  final dynamic details;
  final int? statusCode;

  const AppResponse({
    this.success,
    this.message,
    this.data,
    this.errorCode,
    this.details,
    this.statusCode,
  });

  bool get isSuccess {
    if (success == false) return false;
    if (success == true) return true;
    final code = statusCode;
    if (code != null) return code >= 200 && code < 300;
    return errorCode == null || errorCode!.trim().isEmpty;
  }

  Map<String, dynamic>? get dataAsMap {
    if (data is Map) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }

  List<dynamic>? get dataAsList {
    if (data is List) return data as List<dynamic>;
    return null;
  }

  factory AppResponse.fromJson(
    Map<dynamic, dynamic> json,
    int? httpStatusCode,
  ) {
    final map = Map<String, dynamic>.from(json);
    final hasEnvelope = map.containsKey('success');
    final code = _readInt(map['statusCode']) ?? httpStatusCode;
    final isHttpOk = code != null && code >= 200 && code < 300;

    if (hasEnvelope) {
      return AppResponse(
        success: map['success'] is bool ? map['success'] as bool : null,
        message: map['message']?.toString(),
        data: map['data'] ?? map,
        errorCode: map['errorCode']?.toString(),
        details: map['details'],
        statusCode: code,
      );
    }

    return AppResponse(
      success: isHttpOk,
      message: map['message']?.toString(),
      data: map,
      details: map,
      statusCode: code,
    );
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
