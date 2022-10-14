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
                  color: AppColor.gris_3_de3,
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
                      borderRadius: BorderRadius.circular(20),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: widget.indexTap == 0 ? AppColor.lila_1_8ff : AppColor.gris_2_df2,
                        child: Icon(
                          Icons.home,
                          color: widget.indexTap == 0 ? AppColor.morado_2_347 : AppColor.gris_5_d79,
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
                        borderRadius: BorderRadius.circular(20),
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: widget.indexTap == 2 ? AppColor.lila_1_8ff : AppColor.gris_2_df2,
                          child: Icon(
                            Icons.person,
                            color: widget.indexTap == 2 ? AppColor.morado_2_347 : AppColor.gris_5_d79,
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
