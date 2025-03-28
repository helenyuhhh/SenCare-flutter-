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
    switch (category) {
      case 'Respiratory Rate':
        respiratory = json['respiratory'] ?? 0;
        break;
      case 'Blood Oxygen Level':
        bloodOxygen = (json['blood_oxygen'] ?? 0.0).toDouble();
        break;
      case 'Heartbeat Rate':
        heartBeat = json['heartbeat_rate'] ?? 0;
        break;
      case 'Blood Pressure':
        systolic = json['systolic'] ?? 0;
        diastolic = json['diastolic'] ?? 0;
        break;
    }
  }

  Map<String, dynamic> toJson(String category){
    Map<String, dynamic> data = {};
    switch(category){
      case 'Respiratory Rate':
        data['respiratory'] = respiratory;
        break;
      case 'Blood Oxygen Level':
        data['blood_oxygen'] = bloodOxygen;
        break;
      case 'Heartbeat Rate':
        data['heartbeat_rate'] = heartBeat;
        break;
      case 'Blood Pressure':
        data['systolic'] = systolic;
        data['diastolic'] = diastolic;
        break;
    }
    return data;
  }
}

class TestObject {
  Reading reading;
  String patientId = "";
  String date = "";
  String nurseName = "";
  String type = "";
  String category = "";
  String id = "";
  TestObject(this.reading, this.patientId, this.date, this.nurseName, this.type,
      this.category, this.id);

  factory TestObject.fromJson(Map<String, dynamic> json){
    final category = json['category'] as String;
    final reading = Reading.fromJson(json['reading'] as Map<String, dynamic>, category);
    
    return TestObject(
     reading, 
     json['patient_id'] ?? "", 
     json['date'] ?? "", 
     json['nurse_name'] ?? "", 
     json['type'] ?? "",
     category, 
     json['id'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'reading': reading.toJson(category),
      'patient_id': patientId,
      'date': date,
      'nurse_name': nurseName,
      'type': type,
      'category': category,
      'id': id,
    };
  }
}
