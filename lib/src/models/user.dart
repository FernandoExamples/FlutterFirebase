import 'dart:convert';

class User {
    String localId;
    String email;
    String idToken;
    String refreshToken;
    String expiresIn;

    User({
        this.localId,
        this.email,
        this.idToken,
        this.refreshToken,
        this.expiresIn,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    factory User.fromMap(Map<String, dynamic> json) => User(
        localId: json["localId"],
        email: json["email"],
        idToken: json["idToken"],
        refreshToken: json["refreshToken"],
        expiresIn: json["expiresIn"],
    );

    bool get isCorrect{
      return idToken != null;
    }
}