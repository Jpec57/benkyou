import 'package:benkyou/models/User.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertUser(User user);
}