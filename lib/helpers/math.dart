double myDoubleCorrector(double dob, {int? decAmount}) {
  return double.parse(dob.toStringAsFixed(decAmount ?? 2));
}

