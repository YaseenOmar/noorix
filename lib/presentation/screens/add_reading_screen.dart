import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/meter_reading.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/add_meter_reading.dart';
import '../../domain/usecases/get_meter_readings.dart';
import 'invoice_screen.dart';

/// Screen for entering a new meter reading value.
class AddReadingScreen extends StatefulWidget {
  final Customer customer;

  const AddReadingScreen({super.key, required this.customer});

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _addMeterReading = ServiceLocator.instance.get<AddMeterReading>();
  final _getMeterReadings = ServiceLocator.instance.get<GetMeterReadings>();
  final _settingsRepository = ServiceLocator.instance.get<SettingsRepository>();

  final _formKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();
  bool _isSaving = false;
  double _previousReadingValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPreviousReading();
  }

  Future<void> _loadPreviousReading() async {
    final readings = await _getMeterReadings(widget.customer.id);
    if (readings.isNotEmpty) {
      setState(() {
        _previousReadingValue = readings.first.value;
      });
    }
  }

  @override
  void dispose() {
    _readingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قراءة'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer info banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.customer.name.characters.first,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.customer.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'رقم العداد: ${widget.customer.meterNumber}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Previous reading info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('القراءة السابقة:'),
                    Text(
                      '$_previousReadingValue kWh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Section title
              Row(
                children: [
                  Icon(
                    Icons.electric_bolt_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'قيمة القراءة الحالية',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Reading input
              TextFormField(
                controller: _readingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    fontWeight: FontWeight.bold,
                  ),
                  suffixText: 'kWh',
                  suffixStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
                validator: _validateReading,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 12),

              // Hint text
              Text(
                'أدخل قيمة القراءة الحالية للعداد بالكيلوواط',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Save button
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveReading,
                icon: _isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(
                  _isSaving ? 'جاري الحفظ...' : 'حفظ القراءة وإصدار الفاتورة',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateReading(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال قيمة القراءة';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    if (number <= _previousReadingValue) {
      return 'يجب أن تكون القراءة الحالية أكبر من السابقة ($_previousReadingValue)';
    }
    return null;
  }

  Future<void> _saveReading() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final currentValue = double.parse(_readingController.text);
      final pricePerKwh = await _settingsRepository.getPricePerKwh();
      final consumption = currentValue - _previousReadingValue;
      final totalBill = consumption * pricePerKwh;

      final reading = MeterReading(
        id: 0, // Will be assigned by the data source
        customerId: widget.customer.id,
        value: currentValue,
        previousValue: _previousReadingValue,
        consumption: consumption,
        pricePerKwh: pricePerKwh,
        totalBill: totalBill,
        readingDate: DateTime.now(),
      );

      await _addMeterReading(reading);

      if (mounted) {
        // Find the newly added reading (it will have the actual ID)
        final allReadings = await _getMeterReadings(widget.customer.id);
        final savedReading = allReadings.first; // Should be the newest

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => InvoiceScreen(
              customer: widget.customer,
              reading: savedReading,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
