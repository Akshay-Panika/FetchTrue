

class SignUpModel{
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? password;
  final String? referralCode;

  SignUpModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.referralCode,
   });

  factory SignUpModel.fromJson(Map<String, dynamic> json){
    return SignUpModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      referralCode: json['referralCode'],
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'fullName':fullName,
      'email':email,
      'phone':phone,
      'password':password,
      'referralCode':referralCode,
    };
  }
}