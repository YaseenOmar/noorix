import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/meter_reading.dart';
import '../../domain/entities/user.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import 'invoice_screen.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final customersById = {
          for (final item in state.customers) item.id: item,
        };
        final invoices =
            state.allReadings
                .where(
                  (reading) => customersById.containsKey(reading.customerId),
                )
                .map(
                  (reading) => _InvoiceItem(
                    customer: customersById[reading.customerId]!,
                    reading: reading,
                  ),
                )
                .toList()
              ..sort(
                (a, b) =>
                    b.reading.readingDate.compareTo(a.reading.readingDate),
              );
        final totalRevenue = invoices.fold<double>(
          0,
          (sum, invoice) => sum + invoice.reading.totalBill,
        );

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: context.read<AppCubit>().refresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  title: const Text('الفواتير'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      tooltip: 'تحديث',
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: context.read<AppCubit>().refresh,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _InvoicesSummary(
                      count: invoices.length,
                      totalRevenue: totalRevenue,
                    ),
                  ),
                ),
                if (state.status == AppStatus.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (invoices.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyInvoices(
                      colorScheme: colorScheme,
                      theme: theme,
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return _InvoiceTile(
                        item: invoice,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InvoiceScreen(
                                customer: invoice.customer,
                                reading: invoice.reading,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 96)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InvoicesSummary extends StatelessWidget {
  final int count;
  final double totalRevenue;

  const _InvoicesSummary({required this.count, required this.totalRevenue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count فاتورة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الإجمالي: ${totalRevenue.toStringAsFixed(2)} شيكل',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final _InvoiceItem item;
  final VoidCallback onTap;

  const _InvoiceTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        tileColor: colorScheme.surfaceContainerHigh,
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.payments_rounded),
        ),
        title: Text(
          item.customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${dateFormat.format(item.reading.readingDate)} • ${item.reading.consumption.toStringAsFixed(1)} kWh',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.reading.totalBill.toStringAsFixed(2)} ₪',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '#${item.reading.id}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyInvoices extends StatelessWidget {
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _EmptyInvoices({required this.colorScheme, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('لا توجد فواتير بعد', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'أضف قراءة لأحد العملاء لإنشاء أول فاتورة.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceItem {
  final UserEntity customer;
  final MeterReading reading;

  const _InvoiceItem({required this.customer, required this.reading});
}
