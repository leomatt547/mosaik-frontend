import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/child_registration_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // ignore: avoid_print
        print('New tab');
        break;
      case 1:
        // ignore: avoid_print
        print('go to history');
        break;
      case 2:
        // ignore: avoid_print
        print('go to Settings screen');
        break;
      case 3:
        // ignore: avoid_print
        print('Manage Account');
        break;
      case 4:
        // ignore: avoid_print
        print('Create child account');
        Route route =
            MaterialPageRoute(builder: (context) => ChildRegistrationScreen());
        Navigator.push(context, route);
        break;
      case 5:
        storage.remove('token');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        break;
    }
  }

  homeButton(context) {
    if (getToken() == null) {
      return IconButton(
        onPressed: () {
          // Do nothing
        },
        icon: const Icon(Icons.cottage_outlined),
      );
    } else {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        },
        icon: const Icon(Icons.cottage_outlined),
      );
    }
  }

  accountButton(context) {
    if (getToken() == null) {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        icon: const Icon(Icons.account_circle_outlined),
      );
    } else {
      return PopupMenuButton<int>(
        icon: const Icon(Icons.account_circle_rounded),
        color: const Color.fromARGB(255, 196, 196, 196),
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: const [
                Icon(Icons.manage_accounts_rounded),
                SizedBox(width: 8),
                Text(
                  'Manage Account',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 4,
            child: Row(
              children: const [
                Icon(Icons.person_add),
                SizedBox(width: 8),
                Text(
                  'Create Child Account',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 5,
            child: Row(
              children: const [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: Colors.black),
      titleSpacing: 0.0,
      title: Row(children: [
        IconButton(
          onPressed: () {
            // ignore: todo
            // TODO: Next Page when browsing (nice to have)
            // ignore: avoid_print
            print("right");
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        IconButton(
            onPressed: () {
              // ignore: todo
              // TODO: Refresh when browsing
              // ignore: avoid_print
              print("refresh");
            },
            icon: const Icon(Icons.refresh_outlined)),
        homeButton(context),
      ]),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            // ignore: todo
            // TODO: Tab when browsing
            // ignore: avoid_print
            print("box");
          },
          icon: const Icon(Icons.check_box_outline_blank_outlined),
        ),
        accountButton(context),
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          child: PopupMenuButton<int>(
            color: const Color.fromARGB(255, 196, 196, 196),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      'New tab',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text(
                      'History',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 196, 196, 196),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
