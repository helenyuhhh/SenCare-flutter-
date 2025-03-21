// patient model
class Name {
  String first;
  String last;

  Name(this.first, this.last);
}

class PatientObject{
  Name name;
  int age = 0;
  String gender = "";
  String room = "";
  String condition = "";
  String weight = "";
  String height = "";
  String date = "";
  String picture = "";

  PatientObject(
    this.name, this.age, this.gender, this.room, this.condition, this.weight,
    this.height, this.date, this.picture);
}