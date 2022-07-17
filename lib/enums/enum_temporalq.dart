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

extension ParseToItalianString on TemporalQ {
  String toItalianString() {
    switch (this) {
      case TemporalQ.Yes:
        return "Sì";
      case TemporalQ.No:
        return "No";
      case TemporalQ.Sometimes:
        return "Saltuariamente";
      default:
        return this.toShortString();
    }
  }
}