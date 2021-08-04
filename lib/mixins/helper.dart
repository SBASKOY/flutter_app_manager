import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extension/context_extension.dart';

import '../extension/widget_extension.dart';

import '../network/base_error.dart';

import '../widgets/loading_indicator.dart';

mixin Helper {
   nullOrEmpty(val) => val == null || val.toString().isEmpty;

   AppBar backAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.back,
        ),
      );
   Widget errorMessage(state, {double? fonstSize}) {
    return StreamBuilder<String>(
      stream: state.errMessage,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 5),
              child: Text(snapshot.data.toString(),
                  textAlign: TextAlign.center, style: TextStyle(fontSize: fonstSize, color: Colors.red)));
        }
        return SizedBox();
      },
    );
  }

   Widget loadingStream(state, context, Widget widget) => StreamBuilder<bool?>(
      stream: state.loading,
      initialData: false,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!) return progressIndicator(context);
        }
        return widget;
      });

   Widget customError(text) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 5),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)));
  }

   String getErrorMessage(e) {
    if (e is BadRequestError) {
      return "Hata! kod: 400 Mesaj: ${e.msg}";
    } else if (e is AuthorizeError) {
      return "Hata! kod: 401 Mesaj: Oturumunuz sonlanmış.Yeniden giriş yapınız";
    } else if (e is InternalServerError) {
      return 'Hata! InternalServerError ${e.msg}';
    } else if (e is NotFound) {
      return '404 Not Found';
    } else {
      return "$e";
    }
  }

   Widget lineerButton({VoidCallback? onPressed, required String text, bool? reverse}) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.shade300, width: 0.4),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: reverse ?? true
                  ? [
                      Colors.pink.shade600,
                      Colors.purple,
                    ]
                  : [
                      Colors.purple,
                      Colors.pink.shade600,
                    ],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, letterSpacing: 0.5),
            )));
  }

   Widget disableLineerButton({
    required String text,
    required bool conditionals,
    VoidCallback? onPressed,
    Duration? duration,
  }) {
    return AnimatedContainer(
        duration: duration ?? new Duration(seconds: 1),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.shade300, width: 0.4),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: conditionals
                  ? [
                      Colors.pink.shade600,
                      Colors.purple,
                    ]
                  : [Colors.black38, Colors.black87],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, letterSpacing: 0.5),
            )));
  }

  Widget progressIndicator(BuildContext context) => NutsActivityIndicator(
        radius: 15,
        activeColor: context.colorScheme.primary,
        inactiveColor: Colors.grey,
        tickCount: 11,
        startRatio: 0.55,
        animationDuration: Duration(seconds: 1),
      );
   Color hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

   openPage(context, Widget widget) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return widget;
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

   Widget button(BuildContext context, String text, {VoidCallback? onPressed, double? width, Color? color}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color ?? context.primary,
            border: Border.all(color: color ?? context.primary),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

   Widget filledButton(BuildContext context, String text,
      {VoidCallback? onPressed, double? width, TextStyle? textStyle}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: width ?? context.getWidth * .7,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: context.primary,
            border: Border.all(color: context.primary),
            borderRadius: BorderRadius.circular(15)),
        child: Text(text, style: textStyle ?? null),
      ),
    );
  }

   Widget logo(BuildContext context) {
    return Container(
        width: context.getHeight * 0.18,
        height: context.getHeight * 0.18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.secondary,
            border: Border.all(color: context.primary, width: 1)),
        child: ClipOval(
          child: Image(
            image: AssetImage("assets/orbike.png"),
          ),
        ).paddingAll(3));
  }

   bool checkIdenty(String identy) {
    if (identy.length < 11) return false;

    int last = int.parse(identy.substring(10, 11));
    int last2 = int.parse(identy.substring(9, 10));

    int c1 = int.parse(identy.substring(0, 1));
    int c2 = int.parse(identy.substring(1, 2));
    int c3 = int.parse(identy.substring(2, 3));
    int c4 = int.parse(identy.substring(3, 4));
    int c5 = int.parse(identy.substring(4, 5));
    int c6 = int.parse(identy.substring(5, 6));
    int c7 = int.parse(identy.substring(6, 7));
    int c8 = int.parse(identy.substring(7, 8));
    int c9 = int.parse(identy.substring(8, 9));

    int firstSum = (c1 + c3 + c5 + c7 + c9) * 7;
    int secondSum = (c2 + c4 + c6 + c8);
    int ten = ((firstSum - secondSum) % 10);

    int findingLast = ((c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + ten) % 10);

    return (ten == last2 && last == findingLast);
  }

   openPageWithDialog(context, Widget widget) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return widget;
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
