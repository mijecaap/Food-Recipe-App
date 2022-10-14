import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/ui/screens/add_recipe.dart';
import 'package:recipez/Recipe/ui/screens/main_home.dart';
import 'package:recipez/Recipe/ui/screens/profile_recipe.dart';
import 'package:recipez/Recipe/ui/screens/search.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/bottom_nav_bar.dart';


class RecipezApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecipezApp();
  }

}

class _RecipezApp extends State<RecipezApp> {
  int indexTap = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //widgetsChildren[indexTap]
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      bloc: UserBloc(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.blanco,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => indexTap = index);
                },
                children: [
                  MainHome(),
                  AddRecipe(),
                  ProfileRecipe(),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavBar(onTapTapped: onTapTapped, indexTap: indexTap)
              )
            ],
          ),
        ),
      ),
    );
  }

  onTapTapped(int index){
    setState(() {
      indexTap = index;
      _pageController.jumpToPage(index);
    });
  }
}

/*
BottomNavBar(onTapTapped: onTapTapped, indexTap: indexTap)
*/

/*
Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            canvasColor: Colors.white,
            primaryColor: Colors.amber,
          ),
          child: BottomNavigationBar(
              onTap: onTapTapped,
              currentIndex: indexTap,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.amber.shade200,
              selectedItemColor: Colors.amber.shade500,
              type: BottomNavigationBarType.fixed,
              // other params
              backgroundColor: Colors.amber.shade600,
              elevation: 0.0,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 32.0,
                  ),
                  activeIcon: Icon(
                    Icons.home,
                    size: 32.0,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 32.0,
                  ),
                  activeIcon: Icon(
                    Icons.add_box,
                    size: 32.0,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      size: 32.0,
                    ),
                    activeIcon: Icon(
                      Icons.person,
                      size: 32.0,
                    ),
                    label: ""
                ),
              ]
          ),
        )
*/