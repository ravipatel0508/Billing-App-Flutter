import 'package:billing_application/provider/item.dart';
import 'package:billing_application/screens/Edit_Info.dart';
import 'package:billing_application/screens/home_page.dart';
import 'package:billing_application/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemCount(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billling App',
      home: SafeArea(child: MainPage()),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var currentTab=[
    HomePage(),
    EditInformation(),
    UserInfo()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentTab[context.watch<ItemCount>().currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_outlined),
                activeIcon: Icon(Icons.fastfood),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_outlined),
                activeIcon: Icon(Icons.edit),
                label: "Edit"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person),
                label: "Profile"
            )
          ],
        selectedItemColor: Colors.green,
        currentIndex: context.watch<ItemCount>().currentIndex,
        onTap: (value) => context.read<ItemCount>().setIndex(value),
      ),
    );
  }
}

