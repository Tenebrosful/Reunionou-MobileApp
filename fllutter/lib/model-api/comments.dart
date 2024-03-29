import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
part 'comments.c.dart';

@JsonSerializable()
class Author {
  Author({
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.username,
  });

  factory Author.fromJson(Map<String?, dynamic> json) => _$AuthorFromJson(json);
  Map<String?, dynamic> toJson() => _$AuthorToJson(this);
  final String? createdAt;
  final String? id;
  final String? updatedAt;
  final String? username;
}

@JsonSerializable()
class Comment {
  Comment(
      {required this.author_id,
      required this.createdAt,
      required this.event_id,
      required this.id,
      required this.message,
      required this.updatedAt,
      required this.author});

  factory Comment.fromJson(Map<String?, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String?, dynamic> toJson() => _$CommentToJson(this);

  final Author author;
  final String? createdAt;
  final String? author_id;
  final String? event_id;
  final String? id;
  final String? message;
  final String? updatedAt;
}

@JsonSerializable()
class Comments {
  Comments({
    required this.comments,
    required this.count,
  });

  factory Comments.fromJson(Map<String?, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String?, dynamic> toJson() => _$CommentsToJson(this);

  final List<Comment> comments;
  final int count;
}

Future<Comments> fetchComments(String token, String id) async {
  final response = await http.get(
      Uri.parse(
          'http://docketu.iutnc.univ-lorraine.fr:62461/api/event/${id}/comments?embedAuthor=true'),
      headers: <String, String>{'authorization': token});

  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    return Comments.fromJson(res);
  } else {
    throw Exception('Failed to load comments');
  }
}
