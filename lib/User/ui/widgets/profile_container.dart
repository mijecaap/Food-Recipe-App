import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/ui/widgets/options_action_sheet.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/User/ui/widgets/icon_options.dart';

class ProfileContainer extends StatelessWidget {
  late UserBloc userBloc;
  late UserModel user;

  final double heightBox;

  ProfileContainer({required this.heightBox, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
      stream: userBloc.streamFirebase,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return CardLoading(
              height: heightBox,
              borderRadius: BorderRadius.all(Radius.circular(heightBox / 2)),
            );
          case ConnectionState.none:
            return CardLoading(
              height: heightBox,
              borderRadius: BorderRadius.all(Radius.circular(heightBox / 2)),
            );
          case ConnectionState.active:
            return showProfileData(snapshot);
          case ConnectionState.done:
            return showProfileData(snapshot);
        }
      },
    );
  }

  Widget showProfileData(AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.hasError) {
      return CardLoading(
        height: heightBox,
        borderRadius: BorderRadius.all(Radius.circular(heightBox / 2)),
      );
    } else {
      user = UserModel(uid: snapshot.data.uid, name: snapshot.data.displayName, email: snapshot.data.email, photoURL: snapshot.data.photoURL);

      return Container(
        height: heightBox,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColor.thirdyColor,
            borderRadius: BorderRadius.all(Radius.circular(heightBox / 2))
        ),
        padding: EdgeInsets.all(heightBox / 8),
        child: Row(
          children: [
            SizedBox(
              height: heightBox - (heightBox / 4),
              width: heightBox - (heightBox / 4),
              child: CircleAvatar(
                radius: heightBox / 2,
                backgroundImage: NetworkImage(user.photoURL),
                onBackgroundImageError: (Object exception, StackTrace? stackTrace) {
                  return;
                },
              ),
            ),
            SizedBox(width: heightBox / 8),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: Text(
                          user.name,
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        child: Text(
                          user.email,
                          style: GoogleFonts.openSans(
                              color: Colors.black54
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: heightBox - (heightBox / 4),
              width: heightBox - (heightBox / 4),
              child: OptionsActionSheet(
                onPressed: () {
                  userBloc.signOut();
                },
                onPressed2: () {
                  userBloc.getUserId()
                    .then((value) => userBloc.readUser(value)
                      .then((value) => userBloc.updateSubscriptionData(value.uid, value.subscription!)));
                },
                heightIcon: heightBox - (heightBox / 4),
              ),
            ),
          ],
        ),
      );
    }
  }


}