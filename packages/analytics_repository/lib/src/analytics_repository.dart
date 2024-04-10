import "dart:io";

import "package:analytics_repository/analytics_repository.dart";
import "package:equatable/equatable.dart";
import "package:path_provider/path_provider.dart";

/// {@template analytics_failure}
/// A base failure for the analytics repository failures.
/// {@endtemplate}
abstract class AnalyticsFailure with EquatableMixin implements Exception {
  /// {@macro analytics_failure}
  const AnalyticsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template track_event_failure}
/// Thrown when tracking an event fails.
/// {@endtemplate}
class TrackEventFailure extends AnalyticsFailure {
  /// {@macro track_event_failure}
  const TrackEventFailure(super.error);
}

/// {@template set_user_id_failure}
/// Thrown when setting the user identifier fails.
/// {@endtemplate}
class SetUserIdFailure extends AnalyticsFailure {
  /// {@macro set_user_id_failure}
  const SetUserIdFailure(super.error);
}

/// Base class for analytics providers.
abstract class Analytics {
    /// Logs the provided event.
    Future<void> logEvent({
        required String name,
        Map<String, Object?>? parameters,
    });

    /// Sets the user identifier associated with tracked events.
    /// Setting a null [userId] will clear the user identifier.
    Future<void> setUserId({String? userId});
}

/// {@template analytics_repository}
/// Base repository which manages tracking analytics.
/// {@endtemplate}
abstract class AnalyticsRepository {
    /// {@macro analytics_repository}
    const AnalyticsRepository(Analytics analytics)
        : _analytics = analytics;

    final Analytics _analytics;

    /// Tracks the provided [AnalyticsEvent].
    Future<void> track(AnalyticsEvent event) async {
        try {
            await _analytics.logEvent(
                name: event.name,
                parameters: event.properties,
            );
        } catch (error, stackTrace) {
            Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
        }
    }

    /// Sets the user identifier associated with tracked events.
    ///
    /// Setting a null [userId] will clear the user identifier.
    Future<void> setUserId(String? userId) async {
        try {
            await _analytics.setUserId(userId: userId);
        } catch (error, stackTrace) {
            Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
        }
    }
}

/// Repository which manages tracking analytics to a file.
class FileAnalytics implements Analytics {
  // Constructor with optional file parameter
  FileAnalytics([File? file]) {
    _initFile(file); // Initialize the file
  }

  late File _file; // Define _file as a late variable

  // Method to initialize the file
  Future<void> _initFile(File? file) async {
    if (file != null) {
      _file = file;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      const appName = "YourAppName";
      const ulid = "YourMonotonicULID";
      const fileName = "analytics_${appName}_$ulid.txt";

      _file = File("${directory.path}/$fileName");
    }
  }

  @override
  Future<void> setUserId({String? userId}) async {
    // Implementation to set user ID in analytics file
    try {
      // Write user ID to the file
      await _file.writeAsString("User ID: $userId\n", mode: FileMode.append);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    }
  }

  @override
  Future<void> logEvent(
    {required String name, Map<String, Object?>? parameters,}
  ) async {
    // Implementation to log event to the file
    try {
        // Write event to the file
        await _file.writeAsString("$name: $parameters\n",
            mode: FileMode.append,
        );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }
}

/// Repository which manages tracking analytics to a file.
class FileAnalyticsRepository extends AnalyticsRepository {

  FileAnalyticsRepository(FileAnalytics super.analytics);
}
