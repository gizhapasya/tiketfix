class ScheduleModel {
  final int id;
  final int movieId;
  final String studioName;
  final String startTime;
  final double price;

  ScheduleModel({
    required this.id,
    required this.movieId,
    required this.studioName,
    required this.startTime,
    required this.price,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: int.parse(json['id'].toString()),
      movieId: int.parse(json['movie_id'].toString()),
      studioName: json['studio_name'],
      startTime: json['start_time'],
      price: double.parse(json['price'].toString()),
    );
  }
}
