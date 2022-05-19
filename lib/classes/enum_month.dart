enum Month {
  Gennaio,
  Febbraio,
  Marzo,
  Aprile,
  Maggio,
  Giugno,
  Luglio,
  Agosto,
  Settembre,
  Ottobre,
  Novembre,
  Dicembre,
}

extension ParseToString on Month {
  String toShortString() {
    return this.toString().split('.').last;
  }
}