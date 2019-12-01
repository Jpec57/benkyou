import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
  @PrimaryKey()
  final int id;
  final String username;
  int lvl;

  User(this.id, this.username, this.lvl);

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(json['id'], json['username'], json['lvl']);
  }

}