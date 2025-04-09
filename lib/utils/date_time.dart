extension DateFormatter on DateTime {
  String toYyyyMmDd() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
