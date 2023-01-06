class Medication {
  String? key;
  MedicationData? medicationData;

  Medication({this.key, this.medicationData});
}

class MedicationData {
  String? name;
  String? dailyIntake;
  String? beforeOrAfterMeal;
  String? totalQty;
  String? intakeTime;
  String? imageName;

  MedicationData({
    this.name,
    this.dailyIntake,
    this.beforeOrAfterMeal,
    this.totalQty,
    this.intakeTime,
    this.imageName,
  });

  MedicationData.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    dailyIntake = json['dailyIntake'];
    beforeOrAfterMeal = json['beforeOrAfterMeal'];
    totalQty = json['totalQty'];
    intakeTime = json['intakeTime'];
    imageName = json['imageName'];
  }
}
