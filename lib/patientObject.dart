// patient model
class Name {
  String first = "";
  String last = "";

  Name(this.first, this.last);

  Name.fromJson(Map<String, dynamic> json){
    first: json['first'];
    last: json['last'];
  }
}

class PatientObject{
  Name name = Name("", "");
  int age = 0;
  String gender = "";
  String room = "";
  String condition = "";
  String weight = "";
  String height = "";
  //DateTime date;
  String picture = "";

  PatientObject(
    this.name, this.age, this.gender, this.room, this.condition, this.weight,
    this.height, this.picture);

  PatientObject.fromJson(Map<String, dynamic> json) {
    Name.fromJson(json['name']);
    age = json['age'];
    gender = json['gender'];
    room = json['room'];
    condition = json['condition'];
    weight = json['weight'];
    height = json['condition'];
    //date = json['date'];
    picture = json['picture'];
  }
}