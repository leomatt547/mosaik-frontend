import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/history_screen.dart';
import 'package:mosaic/screen/child_registration_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/list_child_history_screen.dart';
import 'package:mosaic/screen/login.dart';
import 'package:mosaic/screen/update_profile_screen.dart';
import 'package:mosaic/widgets/button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // ignore: avoid_print
        print('New tab');
        break;
      case 1:
        late Uri url;

        if (storage.read('parent_id') != null) {
          url = Uri.parse(API_URL +
              "/parentvisits?parent_id=" +
              storage.read('parent_id').toString());
        } else {
          url = Uri.parse(API_URL +
              "/childvisits?child_id=" +
              storage.read('child_id').toString());
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(
                url: url,
              ),
            ));
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const ChildListHistoryScreen()),
        );
        break;
      case 3:
        // ignore: avoid_print
        print('Manage Account');
        Route route = MaterialPageRoute(
            builder: (context) => const UpdateProfileScreen());
        Navigator.push(context, route);
        break;
      case 4:
        // ignore: avoid_print
        print('Create child account');
        Route route = MaterialPageRoute(
            builder: (context) => const ChildRegistrationScreen());
        Navigator.push(context, route);
        break;
      case 6:
        storage.remove('token');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        break;
      case 7:
        Alert(
          context: context,
          type: AlertType.warning,
          title: 'Delete Account',
          desc: 'Are you sure want to delete this account?',
          style: AlertStyle(
              titleStyle: GoogleFonts.average(
                fontWeight: FontWeight.w500,
              ),
              descStyle: GoogleFonts.average(
                fontWeight: FontWeight.w500,
              )),
          buttons: [
            deleteAccountButton(context),
            cancelButton(context),
          ],
        ).show();
    }
  }

  homeButton(context) {
    if (getToken() == null) {
      return const IconButton(
        onPressed: null,
        icon: Icon(Icons.cottage_outlined),
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

  handleUserTypeAccountButton(context) {
    if (storage.read('parent_id') != null) {
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
          PopupMenuItem<int>(
            value: 7,
            child: Row(
              children: const [
                Icon(Icons.delete_forever_outlined),
                SizedBox(width: 8),
                Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
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
            value: 6,
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
          PopupMenuItem<int>(
            value: 6,
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

  accountButton(context) {
    if (getToken() == null) {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        icon: const Icon(Icons.account_circle_outlined),
      );
    } else {
      return handleUserTypeAccountButton(context);
    }
  }

  handleLoginState(context) {
    if (getToken() == null) {
      return AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0.0,
        leading: const IconButton(
          onPressed: null,
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(children: [
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.arrow_forward),
          ),
          const IconButton(onPressed: null, icon: Icon(Icons.refresh_outlined)),
          homeButton(context),
        ]),
        actions: <Widget>[
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.check_box_outline_blank_outlined),
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
              itemBuilder: (context) => [],
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      );
    } else {
      return AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            // ignore: todo
            // TODO: Next Page when browsing (nice to have)
            // ignore: avoid_print
            print("left");
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
                if (storage.read('parent_id') != null) const PopupMenuDivider(),
                if (storage.read('parent_id') != null)
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.history),
                        SizedBox(width: 8),
                        Text(
                          'History Child',
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
  }

  @override
  Widget build(BuildContext context) {
    return handleLoginState(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
