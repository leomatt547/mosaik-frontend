import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/child_delete_screen.dart';
import 'package:mosaic/screen/children_history/children_list_history_screen.dart';
import 'package:mosaic/screen/delete_child/delete_child_screen.dart';
import 'package:mosaic/screen/edit_profile/edit_profile_screen.dart';
import 'package:mosaic/screen/downloads/downloads_screen.dart';
import 'package:mosaic/screen/history/history_screen.dart';
import 'package:mosaic/screen/landing/landing_screen.dart';
import 'package:mosaic/screen/login/login_screen.dart';
import 'package:mosaic/screen/register_child/register_child_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/widgets/button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:nb_utils/nb_utils.dart';

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
        HistoryScreen(url: url).launch(context);
        break;
      case 2:
        ChildrenListHistoryScreen().launch(context);
        break;
      case 3:
        // ignore: avoid_print
        print('Manage Account');
        EditProfileScreen().launch(context);
        break;
      case 4:
        // ignore: avoid_print
        print('Create child account');
        RegisterChildScreen().launch(context);
        break;
      case 5:
        storage.remove('token');
        const LoginScreen().launch(context);
        break;
      case 6:
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
        break;
      case 7:
        DeleteChildScreen().launch(context);
        break;
      case 8:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DownloadsScreen()),
        );
        break;
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
          const LandingScreen().launch(context);
        },
        icon: const Icon(Icons.cottage_outlined),
      );
    }
  }

  handleUserTypeAccountButton(context) {
    if (storage.read('parent_id') != null) {
      return PopupMenuButton<int>(
        icon: const Icon(Icons.account_circle_rounded),
        color: Colors.white,
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: const [
                Icon(Icons.manage_accounts_rounded, color: primaryColor),
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
                Icon(Icons.delete_forever_outlined, color: primaryColor),
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
                Icon(Icons.person_add, color: primaryColor),
                SizedBox(width: 8),
                Text(
                  'Create Child Account',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 7,
            child: Row(
              children: const [
                Icon(Icons.delete_forever_outlined, color: primaryColor),
                SizedBox(width: 8),
                Text(
                  'Delete Child Account',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 5,
            child: Row(
              children: const [
                Icon(Icons.logout, color: primaryColor),
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
        color: Colors.white,
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

  accountButton(context) {
    if (getToken() == null) {
      return IconButton(
        onPressed: () {
          const LoginScreen().launch(context);
        },
        icon: const Icon(
          Icons.account_circle_outlined,
          color: primaryColor,
        ),
      );
    } else {
      return handleUserTypeAccountButton(context);
    }
  }

  handleLoginState(context) {
    if (getToken() == null) {
      return AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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
            ),
            child: PopupMenuButton<int>(
              color: Colors.white,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [],
            ),
          ),
        ],
        backgroundColor: Colors.white,
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
            ),
            child: PopupMenuButton<int>(
              color: Colors.white,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: primaryColor),
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
                      Icon(Icons.history, color: primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'History',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 8,
                  child: Row(
                    children: const [
                      Icon(Icons.download, color: primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Downloads',
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
                        Icon(Icons.history, color: primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Children History',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white,
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
