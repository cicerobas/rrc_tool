class Item {
  String id;
  String serialNumber;
  String? situation;
  String? reportedProblem;
  String? realProblem;
  String? cause;
  String? immediateAction;
  String? technicalAdvice;

  Item(this.id, this.serialNumber, this.situation, this.reportedProblem,
      this.realProblem, this.cause, this.immediateAction, this.technicalAdvice);
}
