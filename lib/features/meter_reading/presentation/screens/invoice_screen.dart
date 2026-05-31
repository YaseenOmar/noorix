import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/meter_reading.dart';

class InvoiceScreen extends StatelessWidget {
  final Customer customer;
  final MeterReading reading;

  const InvoiceScreen({
    super.key,
    required this.customer,
    required this.reading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الفاتورة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share logic can be implemented here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'فاتورة كهرباء',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'رقم القراءة: #${reading.id}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.receipt_long,
                          size: 48,
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _InvoiceRow(label: 'اسم المشترك', value: customer.name),
                        _InvoiceRow(label: 'رقم العداد', value: customer.meterNumber),
                        _InvoiceRow(label: 'تاريخ القراءة', value: dateFormat.format(reading.readingDate)),
                        const Divider(height: 32),
                        _InvoiceRow(
                          label: 'القراءة الحالية',
                          value: '${reading.value.toStringAsFixed(1)} kWh',
                        ),
                        _InvoiceRow(
                          label: 'القراءة السابقة',
                          value: '${reading.previousValue.toStringAsFixed(1)} kWh',
                        ),
                        _InvoiceRow(
                          label: 'الاستهلاك',
                          value: '${reading.consumption.toStringAsFixed(1)} kWh',
                          isBold: true,
                        ),
                        const Divider(height: 32),
                        _InvoiceRow(
                          label: 'سعر الوحدة',
                          value: '${reading.pricePerKwh.toStringAsFixed(2)} شيكل',
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _InvoiceRow(
                            label: 'إجمالي الفاتورة',
                            value: '${reading.totalBill.toStringAsFixed(2)} شيكل',
                            isBold: true,
                            valueColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('إغلاق'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _InvoiceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
