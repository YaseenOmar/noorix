import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import 'invoice_screen.dart';

/// Screen for entering a new meter reading value.
class AddReadingScreen extends StatefulWidget {
  final UserEntity customer;

  const AddReadingScreen({super.key, required this.customer});

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreviousReading();
  }

  Future<void> _loadPreviousReading() async {
    await context.read<AppCubit>().loadReadings(widget.customer.id);
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
    final state = context.watch<AppCubit>().state;
    final readings = state.readingsFor(widget.customer.id);
    final previousReadingValue = readings.isEmpty ? 0.0 : readings.first.value;
    final isSaving = state.submissionStatus == SubmissionStatus.loading;

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
                      '$previousReadingValue kWh',
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
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.error, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
                validator: (value) =>
                    _validateReading(value, previousReadingValue),
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
                onPressed: isSaving ? null : _saveReading,
                icon: isSaving
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
                  isSaving ? 'جاري الحفظ...' : 'حفظ القراءة وإصدار الفاتورة',
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

  String? _validateReading(String? value, double previousReadingValue) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال قيمة القراءة';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    if (number <= previousReadingValue) {
      return 'يجب أن تكون القراءة الحالية أكبر من السابقة ($previousReadingValue)';
    }
    return null;
  }

  Future<void> _saveReading() async {
    if (!_formKey.currentState!.validate()) return;

    final currentValue = double.parse(_readingController.text);
    final savedReading = await context.read<AppCubit>().addReading(
      customer: widget.customer,
      currentValue: currentValue,
    );
    if (!mounted) return;
    if (savedReading != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              InvoiceScreen(customer: widget.customer, reading: savedReading),
        ),
      );
    } else {
      final error = context.read<AppCubit>().state.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${error ?? 'تعذر حفظ القراءة'}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
