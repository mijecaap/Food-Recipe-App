import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Recipe/ui/widgets/options_action_sheet.dart';
import 'package:recipez/Shared/model/app_color.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/payment.dart';

class ProfileContainer extends StatelessWidget {
  late UserBloc userBloc;
  late UserModel user;

  ProfileContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
      stream: userBloc.streamFirebase,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CardLoading(
              height: 54,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            );
          case ConnectionState.none:
            return const CardLoading(
              height: 54,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            );
          case ConnectionState.active:
            return FutureBuilder(
              future: userBloc.futureAccessToken,
              builder: (BuildContext context, AsyncSnapshot snapshotToken) {
                if (snapshotToken.hasData) {
                  return showProfileData(snapshot, snapshotToken, context);
                }
                return showProfileData(snapshot, snapshotToken, context);
              },
            );
          case ConnectionState.done:
            return FutureBuilder(
              future: userBloc.futureAccessToken,
              builder: (BuildContext context, AsyncSnapshot snapshotToken) {
                if (snapshotToken.hasData) {
                  return showProfileData(snapshot, snapshotToken, context);
                }
                return Container();
              },
            );
        }
      },
    );
  }

  Widget showProfileData(AsyncSnapshot snapshot, AsyncSnapshot snapshotToken, context) {
    if (!snapshot.hasData || snapshot.hasError) {
      return const CardLoading(
        height: 54,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      );
    } else {
      user = UserModel(
        uid: snapshot.data.uid,
        name: snapshot.data.displayName,
        email: snapshot.data.email,
        photoURL: snapshotToken.data != null ? snapshot.data.photoURL + '?height=500&access_token=' + snapshotToken.data.token : snapshot.data.photoURL
      );

      return Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColor.gris_1_8fa,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10
        ),
        child: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.photoURL),
                onBackgroundImageError: (Object exception, StackTrace? stackTrace) {
                  return;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      user.name,
                      style: GoogleFonts.roboto(
                        color: AppColor.negro,
                        fontSize: 16
                      ),
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      user.email,
                      style: GoogleFonts.openSans(
                        color: AppColor.gris_5_d79,
                        fontSize: 12
                      ),
                    ),
                  )
                ],
              ),
            ),
            /*GestureDetector(
              onTap: () {
                /*userBloc.signOut();*/
                userBloc.getUserId()
                    .then((value) => userBloc.readUser(value)
                    .then((value) {
                      if(!value.subscription!){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                            onFinish: (number) async {

                            // payment done
                            userBloc.getUserId()
                                .then((value) => userBloc.readUser(value)
                                .then((value) => userBloc.updateSubscriptionData(value.uid, true, number)));


                            },
                          ),
                        ));
                      } else {
                        ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.info,
                              title: "Ya se encuentra suscrito",
                            )
                        );
                      }
                }));
              },
              child: const Icon(
                Icons.more_horiz,
                size: 24,
              ),
            )*/
            OptionsActionSheet(
              onPressed: () {
                userBloc.signOut();
              },
              onPressed2: () {
                userBloc.getUserId()
                    .then((value) => userBloc.readUser(value)
                    .then((value) {
                  if(!value.subscription!){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => PaypalPayment(
                        onFinish: (number) async {

                          // payment done
                          userBloc.getUserId()
                              .then((value) => userBloc.readUser(value)
                              .then((value) => userBloc.updateSubscriptionData(value.uid, true, number)));


                        },
                      ),
                    ));
                  } else {
                    ArtSweetAlert.show(
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.info,
                          title: "Ya se encuentra suscrito",
                        )
                    );
                  }
                }));

                /*
                  userBloc.getUserId()
                    .then((value) => userBloc.readUser(value)
                    .then((value) => userBloc.updateSubscriptionData(value.uid, value.subscription!)));

                 */
              },
            ),
          ],
        ),
      );
    }
  }


}