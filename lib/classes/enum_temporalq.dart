enum TemporalQ {
  Yes,
  No,
  Sometimes,
}

extension ParseToString on TemporalQ {
  String toShortString() {
    return this.toString().split('.').last;
  }
}