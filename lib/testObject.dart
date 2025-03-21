// for test model
class Reading {
  int? heartBeat = 0;
  int? respiratory = 0;
  double? bloodOxygen = 0.0;
  int? systolic = 0;
  int? diastolic = 0;
  Reading(this.heartBeat, this.respiratory, this.bloodOxygen, this.systolic,
  this.diastolic);
  Reading.fromJson(Map<String, dynamic> json, String category) {

  }
}

class TestObject {
  Reading reading;
  String patientId = "";
  DateTime date;
  String nurseName = "";
  String type = "";
  String category = "";
  int id = 0;
  TestObject(this.reading, this.patientId, this.date, this.nurseName, this.category,
  this.id);

}