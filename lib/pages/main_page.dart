import 'package:chat_app/pages/chat_list_page.dart';
import 'package:chat_app/pages/contact_list_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;
  List<Widget> screenWidgets = [
    const ContactListPage(),
    const ChatListPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: currentIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kDefaultBlackColor,
        selectedFontSize: kTextSmall,
        unselectedFontSize: kTextSmall,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        onTap: (selectedIndex) {
          HapticFeedback.mediumImpact();
          setState(() {
            currentIndex = selectedIndex;
          });
        },
        items: _getBottomNavigationItems(),
      ),
      body: screenWidgets[currentIndex],
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigationItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_2),
        activeIcon: Icon(
          CupertinoIcons.person_2_fill,
          color: kPrimaryColor,
        ),
        label: "Contacts",
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.chat_bubble),
        activeIcon: Icon(
          CupertinoIcons.chat_bubble_fill,
          color: kPrimaryColor,
        ),
        label: "Chats",
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_alt_circle),
        activeIcon: Icon(
          CupertinoIcons.person_alt_circle_fill,
          color: kPrimaryColor,
        ),
        label: "Profile",
      ),
    ];
  }
}
