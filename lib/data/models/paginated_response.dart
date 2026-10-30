class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool? hasNextPage;
  final int skip;

  const PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    this.hasNextPage,
    this.skip = 0,
  });

  bool get hasMore => hasNextPage ?? page < totalPages;

  factory PaginationMeta.fromDummyJson(Map<String, dynamic> json) {
    final total = _asInt(json['total']) ?? 0;
    final limit = _asInt(json['limit']) ?? 20;
    final skip = _asInt(json['skip']) ?? 0;
    final page = limit <= 0 ? 1 : (skip ~/ limit) + 1;
    final totalPages = limit <= 0 ? 0 : (total / limit).ceil();
    return PaginationMeta(
      total: total,
      page: page < 1 ? 1 : page,
      limit: limit < 1 ? 20 : limit,
      totalPages: totalPages < 0 ? 0 : totalPages,
      skip: skip,
      hasNextPage: skip + limit < total,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta pagination;

  const PaginatedResponse({required this.items, required this.pagination});

  int get total => pagination.total;

  int get page => pagination.page;

  int get limit => pagination.limit;

  bool get hasMore => pagination.hasMore;

  factory PaginatedResponse.fromDummyJson(
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJsonT, {
    String itemsKey = 'products',
  }) {
    final list = data[itemsKey];
    return PaginatedResponse<T>(
      items: list is List
          ? list
                .whereType<Map>()
                .map((e) => fromJsonT(Map<String, dynamic>.from(e)))
                .toList()
          : <T>[],
      pagination: PaginationMeta.fromDummyJson(data),
    );
  }
}
