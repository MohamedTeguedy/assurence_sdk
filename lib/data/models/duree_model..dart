class DureeResponse {
  final List<int> durees;

  DureeResponse({required this.durees});

  factory DureeResponse.fromJson(Map<String, dynamic> json) {
    return DureeResponse(
      durees: List<int>.from(json['duree']),
    );
  }
}
