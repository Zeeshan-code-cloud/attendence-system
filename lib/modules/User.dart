class User_model{
  String? name;
  String? password;
  String? userimage;

  User_model({
  required   this.name,
    required this.password,
    required this.userimage,}
      );

  factory User_model.fromJson(Map<String,dynamic > map){
    return User_model(name: map["name"], password: map["password"], userimage: map["userimage"]);
  }

  Map<String, dynamic>  ToJosn(){
    return {
      "name" : name,
      "password" :password,
      "userimage" : userimage,
    };
  }
}