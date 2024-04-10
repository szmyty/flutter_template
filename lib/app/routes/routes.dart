import "package:flutter/widgets.dart";
import "package:flutter_template/app/app.dart";
import "package:flutter_template/home/home.dart";

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.onboardingRequired:
      // return [OnboardingPage.page()];
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
