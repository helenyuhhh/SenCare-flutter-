// Patient model
class Name {
  String first = "";
  String last = "";
  
  Name(this.first, this.last);
  
  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      json['first'],
      json['last']
    );
  }
  
  @override
  String toString() => '$first $last';
}

class PatientObject {
  Name name = Name("", "");
  int age = 0;
  String gender = "";
  String room = "";
  String condition = ""; 
  String weight = "";
  String height = "";
  String date = "";
  String picture = "";
  
  PatientObject(this.name, this.age, this.gender, this.room, this.condition,
    this.weight, this.height,this.date, this.picture);
  
  factory PatientObject.fromJson(Map<String, dynamic> json) {
    return PatientObject(
      Name.fromJson(json['name']),
      json['age'],
      json['gender'],
      json['room'],
      json['condition'],
      json['weight'],
      json['height'],
      json['date'],
      json['picture']
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': {
        'first': name.first,
        'last': name.last
      },
      'age': age,
      'gender': gender,
      'room': room,
      'condition': condition,
      'weight': weight,
      'height': height,
      'date': date,
      'picture': picture
    };
  }
}