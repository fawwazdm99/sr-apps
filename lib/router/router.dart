import 'package:flutter/material.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/addGuest.dart';
import 'package:sr_apps/view/addManual.dart';
import 'package:sr_apps/view/dashboard.dart';
import 'package:sr_apps/view/detailAgenda.dart';
import 'package:sr_apps/view/detailArticle.dart';
import 'package:sr_apps/view/editAgenda.dart';
import 'package:sr_apps/view/editPassword.dart';
import 'package:sr_apps/view/editProfile.dart';
import 'package:sr_apps/view/error.dart';
import 'package:sr_apps/view/home.dart';
import 'package:sr_apps/view/listAgenda.dart';
import 'package:sr_apps/view/listPeserta.dart';

import 'package:sr_apps/view/login.dart';
import 'package:sr_apps/view/profile.dart';
import 'package:sr_apps/view/qrCode.dart';
import 'package:sr_apps/view/signup.dart';
import 'package:sr_apps/view/splashScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case SplashScreenViewRoute:
      return MaterialPageRoute(builder: (context) => SplashScreenView());
    case DashboardViewRoute:
      return MaterialPageRoute(builder: (context) => DashboardView());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case SignUpViewRoute:
      return MaterialPageRoute(builder: (context) => SignUpView());
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case QrCodeViewRoute:
      return MaterialPageRoute(builder: (context) => QrCodeView());
    case ListAgendaViewRoute:
      return MaterialPageRoute(builder: (context) => ListAgendaView());
    case DetailAgendaViewRoute:
      return MaterialPageRoute(
          builder: (context) => DetailAgendaView(
                data: args,
              ));
    case ListPesertaViewRoute:
      return MaterialPageRoute(
          builder: (context) => ListPesertaView(
                data: args,
              ));
    case AddGuestViewRoute:
      return MaterialPageRoute(
          builder: (context) => AddGuestView(
                data: args,
              ));
    case ProfileViewRoute:
      return MaterialPageRoute(builder: (context) => ProfileView());
    case EditProfileViewRoute:
      return MaterialPageRoute(
          builder: (context) => EditProfileView(
                data: args,
              ));
    case EditAgendaViewRoute:
      return MaterialPageRoute(
          builder: (context) => EditAgendView(
                data: args,
              ));
    case EditPasswordViewRoute:
      return MaterialPageRoute(builder: (context) => EditPasswordView());
    case AddManualViewRoute:
      return MaterialPageRoute(
          builder: (context) => AddManualView(
                data: args,
              ));
    case DetailArticleViewRoute:
      return MaterialPageRoute(
          builder: (context) => DetailArticleView(
                data: args,
              ));
    default:
      return MaterialPageRoute(builder: (context) => ErrorView());
  }
}
