import '../../domain/entities/meter_reading.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/home_stats.dart';

enum AppStatus { initial, loading, ready, failure }

enum SubmissionStatus { idle, loading, success, failure }

class AppState {
  const AppState({
    this.status = AppStatus.initial,
    this.submissionStatus = SubmissionStatus.idle,
    this.hasSeenOnboarding = false,
    this.navigationIndex = 0,
    this.customers = const [],
    this.allReadings = const [],
    this.readingsByCustomer = const {},
    this.homeStats,
    this.pricePerKwh = 0,
    this.lastAddedReading,
    this.errorMessage,
  });

  final AppStatus status;
  final SubmissionStatus submissionStatus;
  final bool hasSeenOnboarding;
  final int navigationIndex;
  final List<UserEntity> customers;
  final List<MeterReading> allReadings;
  final Map<int, List<MeterReading>> readingsByCustomer;
  final HomeStats? homeStats;
  final double pricePerKwh;
  final MeterReading? lastAddedReading;
  final String? errorMessage;

  List<MeterReading> readingsFor(int customerId) =>
      readingsByCustomer[customerId] ?? const [];

  AppState copyWith({
    AppStatus? status,
    SubmissionStatus? submissionStatus,
    bool? hasSeenOnboarding,
    int? navigationIndex,
    List<UserEntity>? customers,
    List<MeterReading>? allReadings,
    Map<int, List<MeterReading>>? readingsByCustomer,
    HomeStats? homeStats,
    double? pricePerKwh,
    MeterReading? lastAddedReading,
    String? errorMessage,
    bool clearError = false,
    bool clearLastAddedReading = false,
  }) {
    return AppState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      navigationIndex: navigationIndex ?? this.navigationIndex,
      customers: customers ?? this.customers,
      allReadings: allReadings ?? this.allReadings,
      readingsByCustomer: readingsByCustomer ?? this.readingsByCustomer,
      homeStats: homeStats ?? this.homeStats,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      lastAddedReading: clearLastAddedReading
          ? null
          : lastAddedReading ?? this.lastAddedReading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
