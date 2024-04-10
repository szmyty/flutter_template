import "package:ads_consent_client/ads_consent_client.dart";
import "package:always_authenticated_authentication_client/always_authenticated_authentication_client.dart";
import "package:app_ui/app_ui.dart";
import "package:article_repository/article_repository.dart";
import "package:deep_link_client/deep_link_client.dart";
import "package:firebase_authentication_client/firebase_authentication_client.dart";
import "package:firebase_notifications_client/firebase_notifications_client.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_template/app/app.dart";
import "package:flutter_template/l10n/l10n.dart";
import "package:flutter_template/main/bootstrap/bootstrap.dart";
import "package:flutter_template/src/version.dart";
import "package:flutter_template_api/client.dart";
import "package:in_app_purchase_repository/in_app_purchase_repository.dart";
import "package:news_repository/news_repository.dart";
import "package:notifications_repository/notifications_repository.dart";
import "package:package_info_client/package_info_client.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:permission_client/permission_client.dart";
import "package:persistent_storage/persistent_storage.dart";
import "package:purchase_client/purchase_client.dart";
import "package:token_storage/token_storage.dart";
import "package:user_repository/user_repository.dart";

void main() {
  BindingBase.debugZoneErrorsAreFatal = true;
  bootstrap(
    (
      sharedPreferences,
      analyticsRepository,
    ) async {
      final tokenStorage = InMemoryTokenStorage();

      final apiClient = FlutterTemplateApiClient.localhost(
        tokenProvider: tokenStorage.readToken,
      );

      const permissionClient = PermissionClient();

      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

    final packageInfo = await PackageInfo.fromPlatform();

    final packageInfoClient = PackageInfoClient(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      packageVersion: packageInfo.version,
    );

      // final deepLinkClient = DeepLinkClient(
      //   firebaseDynamicLinks: firebaseDynamicLinks,
      // );

      final userStorage = UserStorage(storage: persistentStorage);

      final authenticationClient = AlwaysAuthenticatedAuthenticationClient(
        tokenStorage: tokenStorage,
      );

      // final notificationsClient = FirebaseNotificationsClient(
      //   firebaseMessaging: firebaseMessaging,
      // );

      final userRepository = UserRepository(
        apiClient: apiClient,
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        // deepLinkClient: deepLinkClient,
        storage: userStorage,
      );

      final newsRepository = NewsRepository(
        apiClient: apiClient,
      );

      // final notificationsRepository = NotificationsRepository(
      //   permissionClient: permissionClient,
      //   storage: NotificationsStorage(storage: persistentStorage),
      //   notificationsClient: notificationsClient,
      //   apiClient: apiClient,
      // );

      // final articleRepository = ArticleRepository(
      //   storage: ArticleStorage(storage: persistentStorage),
      //   apiClient: apiClient,
      // );

      // final inAppPurchaseRepository = InAppPurchaseRepository(
      //   authenticationClient: authenticationClient,
      //   apiClient: apiClient,
      //   inAppPurchase: PurchaseClient(),
      // );

      // final adsConsentClient = AdsConsentClient();

      // return TempView();

      return App(
        userRepository: userRepository,
        newsRepository: newsRepository,
        // notificationsRepository: notificationsRepository,
        // articleRepository: articleRepository,
        analyticsRepository: analyticsRepository,
        // inAppPurchaseRepository: inAppPurchaseRepository,
        // adsConsentClient: adsConsentClient,
        user: await userRepository.user.first,
      );
    },
  );
}
