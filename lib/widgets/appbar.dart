import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('New tab');
        break;
      case 1:
        print('go to history');
        break;
      case 2:
        print('go to Settings screen');
        break;
    }
  }

  accountButton() {
    if (getToken() == null) {
      return Icons.account_circle_outlined;
    } else {
      return Icons.account_circle_rounded;
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
            // TODO: Next Page when browsing (nice to have)
            print("right");
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        IconButton(
            onPressed: () {
              // TODO: Refresh when browsing
              print("refresh");
            },
            icon: const Icon(Icons.refresh_outlined)),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          },
          icon: const Icon(Icons.cottage_outlined),
        ),
      ]),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            // TODO: Tab when browsing
            print("box");
          },
          icon: const Icon(Icons.check_box_outline_blank_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(accountButton()),
        ),
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
