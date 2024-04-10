import "dart:async";
import "dart:developer";

import "package:analytics_repository/analytics_repository.dart";
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";
import "package:flutter_template/main/bootstrap/app_bloc_observer.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:path_provider/path_provider.dart";
import "package:shared_preferences/shared_preferences.dart";

typedef AppBuilder = Future<Widget> Function(
    SharedPreferences sharedPreferences,
    AnalyticsRepository analyticsRepository,
);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
        WidgetsFlutterBinding.ensureInitialized();

        final analyticsRepository = FileAnalyticsRepository(FileAnalytics());
        final blocObserver = AppBlocObserver(
            analyticsRepository: analyticsRepository,
        );
        Bloc.observer = blocObserver;
        HydratedBloc.storage = await HydratedStorage.build(
            storageDirectory: await getApplicationSupportDirectory(),
        );

        if (kDebugMode) {
            await HydratedBloc.storage.clear();
        }

          final sharedPreferences = await SharedPreferences.getInstance();

        runApp(
            await builder(
                sharedPreferences,
                analyticsRepository,
            ),
        );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
