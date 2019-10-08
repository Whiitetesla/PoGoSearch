import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

class Post {
  final List<String> types;
  final int combatPoints;
  final int hitPoints;
  final bool attackRelation;
  final bool weaknessType;
  final bool weaknessMove;
  final bool stab;
  final bool doubleSuper;
  final bool onlyWeakness;

  Post({
    this.types,
    this.combatPoints,
    this.hitPoints,
    this.attackRelation,
    this.weaknessType,
    this.weaknessMove,
    this.stab,
    this.doubleSuper,
    this.onlyWeakness});

  factory Post.fromJson(Map<String, dynamic> json) {

    var typesJson = json['types'];

    return Post(
      types: new List<String>.from(typesJson),
      combatPoints: json['combatPoints'],
      hitPoints: json['hitPoints'],
      attackRelation: json['attackRelation'],
      weaknessType: json['weaknessType'],
      weaknessMove: json['weaknessMove'],
      stab: json['stab'],
      doubleSuper: json['doubleSuper'],
      onlyWeakness: json['onlyWeakness'],
    );
  }

  Map toMap() {

    var map = new Map<String, dynamic>();
    map["types"] = types;
    map["combatPoints"] = combatPoints.toString();
    map["hitPoints"] = hitPoints.toString();
    map["attackRelation"] = attackRelation.toString();
    map["weaknessType"] = weaknessType.toString();
    map["weaknessMove"] = weaknessMove.toString();
    map["stab"] = stab.toString();
    map["doubleSuper"] = doubleSuper.toString();
    map["onlyWeakness"] = onlyWeakness.toString();

    return map;
  }
}

Future<String> createSearchString(String url, {Map body}) async {
  Map<String, String> headers = {"Content-type": "application/json"};

  return http.post(url, headers: headers, body: json.encode(body)).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return response.body;
  });
}

Future<String> fetchTypes(String url) {
  return http.get(url).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return json.decode(response.body).toString();
  });
}