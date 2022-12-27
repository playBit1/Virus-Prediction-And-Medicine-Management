class PillManager {
  void addMedicine() {}
  void viewMedicine() {}
  void updateMedicine() {}
  void deleteMedicine() {}
}

class Pill {
  String name;
  int totalQty;
  bool beforeOrAfterMeal;
  int intakeQty;
  int intakeTime;
  bool intakeDaily;
  List<bool> selectedDays;

  Pill(this.name, this.totalQty, this.beforeOrAfterMeal, this.intakeQty,
      this.intakeTime, this.intakeDaily, this.selectedDays);
}
