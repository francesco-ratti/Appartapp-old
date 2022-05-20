enum Gender {
  M,
  F,
  NB
}

extension ParseToString on Gender {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

extension ParseToItalianString on Gender {
  String toItalianString() {
    switch (this) {
      case Gender.M:
        return "Maschile";
      case Gender.F:
        return "Femminile";
      case Gender.NB:
        return "Non binario";
      default:
        return this.toShortString();
    }
  }
}