import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'users.u.dart';

@JsonSerializable()
class User {
  User({
    required this.createdAt,
    required this.default_event_mail,
    required this.id,
    //required this.last_connexion,
    required this.updatedAt,
    required this.username,
  });

  factory User.fromJson(Map<String?, dynamic> json) => _$UserFromJson(json);
  Map<String?, dynamic> toJson() => _$UserToJson(this);

  final String? createdAt;
  final String? default_event_mail;
  final String? id;
  //final String? last_connexion;
  final String? updatedAt;
  final String? username;
}

/*
@JsonSerializable()
class Users {
  Users({
    required this.users,
    required this.count,
  });

  factory Users.fromJson(Map<String?, dynamic> json) => _$ApiFromJson(json);
  Map<String?, dynamic> toJson() => _$ApiToJson(this);

  final List<User> users;
  final int count;
}
*/
/*
Future<Users> fetchUser() async {
  final response = await http
      .get(Uri.parse('http://docketu.iutnc.univ-lorraine.fr:62460/api/user'));

  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    return Users.fromJson(res);
  } else {
    throw Exception('Failed to load user');
  }
}
*/

Future<User> fetchUser(String id, String token) async {
  final response = await http.get(
    Uri.parse('http://docketu.iutnc.univ-lorraine.fr:62461/api/user/' + id),
    headers: <String, String>{
      'Authorization': token,
    },
  );

  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    return User.fromJson(res);
  } else {
    print(response.body);
    throw Exception('Failed to load user');
  }
}

Future<void> patchUser(
    String id, String token, String mail, String username) async {
  final response = await http.patch(
    Uri.parse('http://docketu.iutnc.univ-lorraine.fr:62461/api/user/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      'authorization': token,
      "user-agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.83 Safari/537.36"
    },
    body: jsonEncode(
        <String, dynamic>{"default_mail": mail, "username": username}),
  );

  if (response.statusCode == 204) {
  } else {
    print(response.body);

    throw Exception('Failed to patch user');
  }
}
