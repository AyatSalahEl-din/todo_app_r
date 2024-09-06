import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/add_task_bot_sheet.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/login/login.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/user_provider.dart';
import 'package:todo_app/settings_tab.dart';
import 'package:todo_app/task_list_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: Text(
          selectedIndex == 0
              ? '${AppLocalizations.of(context)!.app_title}{${userProvider.currentUser!.name}}'
              : AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                listProvider.tasksList = [];
                //userProvider.currentUser = null;
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              icon: Icon(
                Icons.logout,
                color: AppColors.whiteColor,
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                size: 22,
              ),
              label: AppLocalizations.of(context)!.task_list,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 22,
              ),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          selectedItemColor: Color(0xff5D9CEC),
          showUnselectedLabels: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.whiteColor,
            width: 5,
          ),
        ),
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: selectedIndex == 0 ? TaskListTab() : SettingsTab(),
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }

  // List<Widget> tabs = [TaskListTab(), SettingsTab()];
}
