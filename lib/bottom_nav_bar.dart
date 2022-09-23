import 'package:flutter/material.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/custom_nav_item.dart';
import 'package:recipez/wave-clip.dart';


class BottomNavBar extends StatefulWidget {

  final Function onTapTapped;
  int indexTap;

  BottomNavBar({required this.onTapTapped, required this.indexTap, Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.0,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.secondaryColor.withOpacity(0.8),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomNavItem(
                      setPage: widget.onTapTapped,
                      indexTap: widget.indexTap,
                      icon: Icons.add,
                      id: 1),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      widget.onTapTapped(0);
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: widget.indexTap == 0 ? Colors.white : AppColor.secondaryColor,
                        child: Icon(
                          Icons.home,
                          color: widget.indexTap == 0 ? AppColor.secondaryColor : Colors.white,
                        ),
                      ),
                    )
                  ),
                  Container(),
                  GestureDetector(
                      onTap: () {
                        widget.onTapTapped(2);
                      },
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: widget.indexTap == 2 ? Colors.white : AppColor.secondaryColor,
                          child: Icon(
                            Icons.person,
                            color: widget.indexTap == 2 ? AppColor.secondaryColor : Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
