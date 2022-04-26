import 'package:flutter/material.dart';
import 'package:friends_app/Back-End/friends_service.dart';
import 'package:friends_app/Back-End/friendsmodal.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List family = [];
  // Color iconColor = Colors.lightBlue;

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    var value = await FriendsService().readAllFriends();

    family = <Friends>[];

    family = value.map((value) => Friends.fromJson(value)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.tealAccent,
        body: ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(
        family.length,
        (index) => Card(
          child: ListTile(
            title: Text(family[index].name!),
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.view_agenda, color: family[index].iconColor),
                  onPressed: () {
                    setState(() {
                      family[index].iconColor = Colors.greenAccent;

                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                          ),
                          // backgroundColor: Colors.cyan,
                          // barrierColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext bc) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: Wrap(
                                children: <Widget>[
                                  
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Text(family[index].name!),
                                  ),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.date_range_outlined),
                                    title: Text(family[index].dob!),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.mobile_friendly),
                                    title: Text(family[index].mobileNo!),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.category),
                                    title: Text(family[index].category!),
                                  )
                                ],
                              ),
                            );
                          });
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
