import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:fllutter/components/geolocalisation_self_event.dart';
import 'package:flutter/material.dart';
import 'package:fllutter/components/appbar_widget.dart';
import 'package:fllutter/components/profile_widget.dart';
import 'package:fllutter/components/edit_profile_page.dart';
import 'package:fllutter/themes.dart';
import 'package:fllutter/src/users.dart';
import 'package:fllutter/src/users.dart' as user;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var isDarkMode = false;
  static const String _title = 'Profil';
  String? token;
  String? owner_id;
  final storage = FlutterSecureStorage();

  Future<void> getToken() async {
    token = await storage.read(key: "token");
  }

  Future<void> getUser() async {
    owner_id = await storage.read(key: "id");
  }

  @override
  void initState() {
    getUser().then((owner_id) {
      setState(() {
        owner_id = owner_id;
      });
    });
    getToken().then((token) {
      setState(() {
        token = token;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue[600],
      ),
      body: FutureBuilder<user.User>(
        future: user.fetchUser(owner_id.toString(), token.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!;
            return ThemeProvider(
              initTheme: isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
              builder: (context, myTheme) {
                return /*MaterialApp(
                  title: _title,
                  theme: myTheme,
                  home: ThemeSwitchingArea(
                    child: Builder(
                      builder: (context) => */
                    Scaffold(
                  body: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 24),
                      ProfileWidget(
                        imagePath:
                            "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
                        onClicked: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      buildName(user),
                      const SizedBox(height: 48),
                      buildId(user),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Widget buildName(User user) => Column(
      children: [
        Text(
          user.username.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.default_event_mail.toString(),
          style: TextStyle(color: Colors.grey),
        )
      ],
    );

Widget buildId(User user) => Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.id.toString(),
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
