import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/Recipe/bloc/bloc_recipe.dart';
import 'package:recipez/Recipe/ui/screens/search.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/User/bloc/bloc_user.dart';

class ButtonSearch extends StatelessWidget {
  final double heightBox;
  UserBloc userBloc;

  ButtonSearch({required this.heightBox, required this.userBloc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.thirdyColor,
          borderRadius: BorderRadius.all(Radius.circular(heightBox / 4))
      ),
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.all(Radius.circular(heightBox / 4)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(heightBox / 4)),
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
              height: heightBox,
              width: double.infinity,
              padding: EdgeInsets.all(heightBox / 4),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    Text("Search you favorite recipe"),
                    SizedBox(width: heightBox / 4),
                    Icon(Icons.search),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
