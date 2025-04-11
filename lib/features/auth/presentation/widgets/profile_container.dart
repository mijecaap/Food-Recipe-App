import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_event.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/features/recipes/presentation/widgets/options_action_sheet.dart';
import 'package:recipez/features/payment/presentation/pages/paypal_payment_page.dart';

class ProfileContainer extends StatelessWidget {
  final AuthBloc userBloc;
  final User user;

  const ProfileContainer({
    super.key,
    required this.userBloc,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CardLoading(
            height: 54,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          );
        }
        if (state is Authenticated) {
          return _buildProfileData(context, state.user);
        }
        return _buildProfileData(context, user);
      },
    );
  }

  Widget _buildProfileData(BuildContext context, User currentUser) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColor.gris_1_8fa,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(currentUser.photoURL),
              onBackgroundImageError:
                  (Object exception, StackTrace? stackTrace) {},
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
                      currentUser.name,
                      style: GoogleFonts.roboto(
                          color: AppColor.negro, fontSize: 16),
                    )),
                Expanded(
                  flex: 2,
                  child: Text(
                    currentUser.email,
                    style: GoogleFonts.openSans(
                        color: AppColor.gris_5_d79, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          OptionsActionSheet(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutPressed());
            },
            onPressed2: () async {
              if (!currentUser.subscription) {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaypalPayment(
                        onFinish: (String paymentId) {
                          context.read<AuthBloc>().add(UpdateUserSubscription(
                                uid: currentUser.uid,
                                subscription: true,
                                paymentId: paymentId,
                              ));
                        },
                      ),
                    ),
                  );
                }
              } else {
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.info,
                    title: "Ya se encuentra suscrito",
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
