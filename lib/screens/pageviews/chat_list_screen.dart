import 'package:flutter/material.dart';
import 'package:flutterapp/models/contact.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/resources/chat_methods.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/pageviews/widgets/contact_view.dart';
import 'package:flutterapp/utils/universal_variables.dart';
import 'package:flutterapp/utils/utilities.dart';
import 'package:flutterapp/widgets/appbar.dart';
import 'package:flutterapp/widgets/custom_tile.dart';
import 'package:flutterapp/widgets/quiet_box.dart';
import 'package:provider/provider.dart';

import 'widgets/new_chat_button.dart';
import 'widgets/user_circle.dart';

class ChatListScreen extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.white,
          onPressed: () => _authMethods.signOut().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }).catchError((e) => print(e)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder(
        stream: _chatMethods.fetchContacts(
          userId: userProvider.getUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.documents;
            if (docList.isEmpty) {
              return QuietBox();
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromMap(docList[index].data);
                return ContactView(contact);
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
