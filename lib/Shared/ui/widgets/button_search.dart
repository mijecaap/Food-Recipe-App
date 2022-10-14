import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/ui/screens/search.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSearch extends StatelessWidget {
  UserBloc userBloc;

  ButtonSearch({required this.userBloc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: AppColor.gris_1_8fa,
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: () {
            userBloc.getUserId()
              .then((uid) => userBloc.readUser(uid)
                .then((user) {
                  if(user.subscription!) {
                    userBloc.getUserId()
                      .then((value) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              bloc: RecipeBloc(),
                              child: Search(value),
                            );
                        })
                      );
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Not subscribed"),
                        content: Text("To deactivate search, go to my profile and purchase the subscription."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      )
                    );
                  }
            }));
          },
          child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search you favorite recipe",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.morado_1_57a
                    ),
                  ),
                  Icon(Icons.search, size: 20),
                ],
              )
          ),
        ),
      ),
    );
  }
}
