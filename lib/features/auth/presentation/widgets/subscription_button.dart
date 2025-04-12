import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_event.dart';
import 'package:recipez/features/payment/presentation/pages/paypal_payment_page.dart';

class SubscriptionButton extends StatelessWidget {
  final User currentUser;

  const SubscriptionButton({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: IconButton(
        key: ValueKey(currentUser.subscription),
        icon: Icon(
          currentUser.subscription ? Icons.star : Icons.star_border,
          color: currentUser.subscription ? Colors.amber : Colors.grey,
        ),
        onPressed: () async {
          if (!currentUser.subscription) {
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (BuildContext context) => PaypalPayment(
                        onFinish: (String paymentId) {
                          context.read<AuthBloc>().add(
                            UpdateUserSubscription(
                              uid: currentUser.uid,
                              subscription: true,
                              paymentId: paymentId,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Gracias por suscribirte!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
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
                title: "Ya te encuentras suscrito",
                text: "Disfruta de todas las funciones premium",
              ),
            );
          }
        },
        tooltip: currentUser.subscription ? 'Suscrito' : 'Suscribirse',
      ),
    );
  }
}
