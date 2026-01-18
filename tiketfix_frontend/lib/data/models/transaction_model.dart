class TransactionModel {
  final int id;
  final String title;
  final String studioName;
  final String startTime;
  final String seats;
  final double totalPrice;
  final String orderDate;
  final String? posterUrl;
  final String code;
  final String status;

  TransactionModel({
    required this.id,
    required this.title,
    required this.studioName,
    required this.startTime,
    required this.seats,
    required this.totalPrice,
    required this.orderDate,
    this.posterUrl,
    required this.code,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      studioName: json['studio_name'],
      startTime: json['start_time'],
      seats: json['seats'],
      totalPrice: double.parse(json['total_price'].toString()),
      orderDate: json['order_date'],
      posterUrl: json['poster_url'],
      code: json['code'] ?? '-',
      status: json['status'] ?? 'unknown',
    );
  }
}
