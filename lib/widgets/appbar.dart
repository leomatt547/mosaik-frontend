import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/register.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          onPressed: () {
            print("left");
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        IconButton(
          onPressed: () {
            print("right");
          },
          icon: const Icon(Icons.arrow_forward),
          color: Colors.black,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          },
          icon: const Icon(Icons.cottage_outlined),
          color: Colors.black,
        ),
        IconButton(
          onPressed: () {
            print("box");
          },
          icon: const Icon(Icons.check_box_outline_blank_outlined),
          color: Colors.black,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RegisterParentPage()),
            );
          },
          icon: const Icon(Icons.account_circle_outlined),
          color: Colors.black,
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
