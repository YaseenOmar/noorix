import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/meter_reading.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/home_stats.dart';
import '../../domain/usecases/add_customer.dart';
import '../../domain/usecases/add_meter_reading.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_all_meter_readings.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/get_home_stats.dart';
import '../../domain/usecases/get_meter_readings.dart';
import '../../domain/usecases/get_onboarding_status.dart';
import '../../domain/usecases/get_price_per_kwh.dart';
import '../../domain/usecases/set_price_per_kwh.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required GetCustomers getCustomers,
    required GetAllMeterReadings getAllMeterReadings,
    required GetMeterReadings getMeterReadings,
    required GetHomeStats getHomeStats,
    required AddCustomer addCustomer,
    required AddMeterReading addMeterReading,
    required GetPricePerKwh getPricePerKwh,
    required SetPricePerKwh setPricePerKwh,
    required GetOnboardingStatus getOnboardingStatus,
    required CompleteOnboarding completeOnboarding,
  }) : _getCustomers = getCustomers,
       _getAllMeterReadings = getAllMeterReadings,
       _getMeterReadings = getMeterReadings,
       _getHomeStats = getHomeStats,
       _addCustomer = addCustomer,
       _addMeterReading = addMeterReading,
       _getPricePerKwh = getPricePerKwh,
       _setPricePerKwh = setPricePerKwh,
       _getOnboardingStatus = getOnboardingStatus,
       _completeOnboarding = completeOnboarding,
       super(const AppState());

  final GetCustomers _getCustomers;
  final GetAllMeterReadings _getAllMeterReadings;
  final GetMeterReadings _getMeterReadings;
  final GetHomeStats _getHomeStats;
  final AddCustomer _addCustomer;
  final AddMeterReading _addMeterReading;
  final GetPricePerKwh _getPricePerKwh;
  final SetPricePerKwh _setPricePerKwh;
  final GetOnboardingStatus _getOnboardingStatus;
  final CompleteOnboarding _completeOnboarding;

  Future<void> initialize() async {
    emit(state.copyWith(status: AppStatus.loading, clearError: true));
    try {
      final values = await Future.wait([
        _getOnboardingStatus(),
        _getCustomers(),
        _getAllMeterReadings(),
        _getHomeStats(),
        _getPricePerKwh(),
      ]);
      emit(
        state.copyWith(
          status: AppStatus.ready,
          hasSeenOnboarding: values[0] as bool,
          customers: values[1] as List<UserEntity>,
          allReadings: values[2] as List<MeterReading>,
          homeStats: values[3] as HomeStats,
          pricePerKwh: values[4] as double,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AppStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final values = await Future.wait([
        _getCustomers(),
        _getAllMeterReadings(),
        _getHomeStats(),
      ]);
      emit(
        state.copyWith(
          status: AppStatus.ready,
          customers: values[0] as List<UserEntity>,
          allReadings: values[1] as List<MeterReading>,
          homeStats: values[2] as HomeStats,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> loadReadings(int customerId) async {
    try {
      final readings = await _getMeterReadings(customerId);
      emit(
        state.copyWith(
          readingsByCustomer: {
            ...state.readingsByCustomer,
            customerId: readings,
          },
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<bool> addCustomer(UserEntity customer) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.loading));
    try {
      await _addCustomer(customer);
      await refresh();
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return false;
    }
  }

  Future<MeterReading?> addReading({
    required UserEntity customer,
    required double currentValue,
  }) async {
    emit(
      state.copyWith(
        submissionStatus: SubmissionStatus.loading,
        clearLastAddedReading: true,
      ),
    );
    try {
      final readings = await _getMeterReadings(customer.id);
      final previousValue = readings.isEmpty ? 0.0 : readings.first.value;
      final price = await _getPricePerKwh();
      final consumption = currentValue - previousValue;
      final reading = MeterReading(
        id: 0,
        customerId: customer.id,
        value: currentValue,
        previousValue: previousValue,
        consumption: consumption,
        pricePerKwh: price,
        totalBill: consumption * price,
        readingDate: DateTime.now(),
      );
      await _addMeterReading(reading);
      final updated = await _getMeterReadings(customer.id);
      await refresh();
      final saved = updated.first;
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.success,
          readingsByCustomer: {
            ...state.readingsByCustomer,
            customer.id: updated,
          },
          lastAddedReading: saved,
        ),
      );
      return saved;
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return null;
    }
  }

  Future<bool> savePrice(double price) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.loading));
    try {
      await _setPricePerKwh(price);
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.success,
          pricePerKwh: price,
          clearError: true,
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return false;
    }
  }

  Future<void> finishOnboarding() async {
    await _completeOnboarding();
    emit(state.copyWith(hasSeenOnboarding: true));
  }

  void selectNavigationIndex(int index) {
    emit(state.copyWith(navigationIndex: index));
  }

  void resetSubmission() {
    emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
  }
}
