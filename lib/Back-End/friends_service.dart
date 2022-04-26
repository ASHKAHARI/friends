import 'package:friends_app/Back-End/repo.dart';
import 'friendsmodal.dart';

class FriendsService {
  late Repo _repo;
  FriendsService() {
    _repo = Repo();
  }

  saveFriends(Friends friends) async {
    //  print(todo);
    return await _repo.insertData('Friends', friends.toJson());
  }

  readAllFriends() async {
    return await _repo.readData('Friends');
  }


  updateFriends(Friends friends) async {
    return await _repo.updateData('Friends', friends.toJson());
}



  
}
