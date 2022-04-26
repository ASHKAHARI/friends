import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_app/Back-End/friends_service.dart';
import 'package:friends_app/screens/friendslist.dart';
import 'package:friends_app/screens/menuscreen.dart';
import '../Back-End/friendsmodal.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final pages = [
    const MyCustomForm(),
    const FriendsList(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) => (setState(() => selectedIndex = index)),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}

TextEditingController dateController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
TextEditingController categoryController = TextEditingController();

var items = ['School Friend', 'College Friend', 'Colleague', 'Fellow Townsman'];

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  FriendsService friendsService = FriendsService();
  String? imageFile;
  final ImagePicker _picker = ImagePicker();

  saveDataToDb() {
    Friends friend = Friends();
    friend.name = nameController.text;
    friend.dob = dateController.text;
    friend.mobileNo = mobileNoController.text;
    friend.category = categoryController.text;
    friend.profilePicture = imageFile.toString();
    friendsService.saveFriends(friend);
    clear();
  }

  clear() {
    nameController.text = "";
    dateController.text = "";
    mobileNoController.text = "";
    categoryController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return (Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter Your Name',
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                controller: nameController,
              ),
            ),
            Card(
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range_sharp),
                  labelText: "Date of birth",
                  hintText: "Insert your dob",
                ),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now());

                  dateController.text = date != null
                      ? date.toIso8601String().replaceAll("T00:00:00.000", "")
                      : "";
                },
              ),
            ),
            Card(
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mobile_friendly),
                  hintText: 'Enter a phone number',
                  labelText: 'Mobile No',
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                maxLength: 10,
                controller: mobileNoController,
              ),
            ),
            Card(
              child: PopupMenuButton<String>(
                // icon: const Icon(Icons.arrow_drop_down),
                child: TextFormField(
                  controller: categoryController,
                  enabled: false,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.category),
                    hintText: 'Enter Your Friends Category',
                    labelText: 'Category',
                  ),
                ),
                //   const Positioned(
                //       top: 13, right: 0, child: Icon(Icons.arrow_drop_down))
                // ],

                onSelected: (String value) {
                  categoryController.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return items.map<PopupMenuItem<String>>((String value) {
                    return PopupMenuItem(child: Text(value), value: value);
                  }).toList();
                },
              ),
            ),
            Center(
                child: imageFile == "" || imageFile == null
                    ? CircleAvatar(
                        child: FloatingActionButton(
                          child: const Icon(Icons.camera_alt),
                          onPressed: () {
                            getFromGallery();
                          },
                        ),
                        radius: 80, // Image radius
                        backgroundImage:
                            const AssetImage('assets/images/wick.jpg'))
                    : CircleAvatar(
                        child: FloatingActionButton(
                          child: const Icon(Icons.camera_alt),
                          onPressed: () {
                            getFromGallery();
                          },
                        ),
                        radius: 80, // Image radius
                        backgroundImage:
                            FileImage(File(imageFile.toString())))),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      saveDataToDb();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saving')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }

  getFromGallery() async {
    // PickedFile? pickedFile = await ImagePicker().getImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 1800,
    //   maxHeight: 1800,
    // );
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image.path;
        print(imageFile);
      });
    }
  }
}
