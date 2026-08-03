import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import 'add_customer_screen.dart';
import 'customers_screen.dart';
import 'invoices_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final stats = state.homeStats;
        final appCubit = context.read<AppCubit>();
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: appCubit.refresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  title: const Text('لوحة الأدمن'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ).then((_) => appCubit.refresh()),
                    ),
                  ],
                ),
                if (state.status == AppStatus.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (stats != null)
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildAdminHeader(theme, colorScheme),
                        const SizedBox(height: 24),
                        Text(
                          'نظرة عامة',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                          children: [
                            _StatCard(
                              label: 'إجمالي العملاء',
                              value: stats.totalCustomers.toString(),
                              icon: Icons.people_rounded,
                              color: Colors.blue,
                            ),
                            _StatCard(
                              label: 'الفواتير الصادرة',
                              value: stats.totalReadings.toString(),
                              icon: Icons.receipt_long_rounded,
                              color: Colors.orange,
                            ),
                            _StatCard(
                              label: 'الاستهلاك الكلي',
                              value:
                                  '${stats.totalConsumption.toStringAsFixed(1)} kWh',
                              icon: Icons.bolt_rounded,
                              color: Colors.amber,
                            ),
                            _StatCard(
                              label: 'إجمالي الدخل',
                              value:
                                  '${stats.totalRevenue.toStringAsFixed(0)} ₪',
                              icon: Icons.payments_rounded,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'إجراءات الأدمن',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _AdminActionGrid(
                          actions: [
                            _AdminAction(
                              label: 'عميل جديد',
                              icon: Icons.person_add_rounded,
                              color: Colors.teal,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddCustomerScreen(),
                                ),
                              ).then((_) => appCubit.refresh()),
                            ),
                            _AdminAction(
                              label: 'العملاء',
                              icon: Icons.people_rounded,
                              color: Colors.blue,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CustomersScreen(),
                                ),
                              ).then((_) => appCubit.refresh()),
                            ),
                            _AdminAction(
                              label: 'الفواتير',
                              icon: Icons.receipt_long_rounded,
                              color: Colors.green,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const InvoicesScreen(),
                                ),
                              ).then((_) => appCubit.refresh()),
                            ),
                            _AdminAction(
                              label: 'سعر الكيلوواط',
                              icon: Icons.tune_rounded,
                              color: Colors.deepPurple,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              ).then((_) => appCubit.refresh()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'تشغيل سريع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _QuickActionTile(
                          label: 'إدارة العملاء',
                          subtitle: 'عرض وبحث وإضافة المشتركين',
                          icon: Icons.person_search_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomersScreen(),
                            ),
                          ).then((_) => appCubit.refresh()),
                        ),
                        const SizedBox(height: 12),
                        _QuickActionTile(
                          label: 'متابعة الفواتير',
                          subtitle: 'عرض كل الفواتير الصادرة من القراءات',
                          icon: Icons.manage_search_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvoicesScreen(),
                            ),
                          ).then((_) => appCubit.refresh()),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings_rounded,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'نوريكس أدمن',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'إدارة قراءات العدادات والفواتير والعملاء بواجهة واحدة.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _HeaderChip(
                icon: Icons.verified_user_rounded,
                label: 'وضع الأدمن',
              ),
              _HeaderChip(
                icon: Icons.cloud_off_rounded,
                label: 'بيانات تجريبية',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminActionGrid extends StatelessWidget {
  final List<_AdminAction> actions;

  const _AdminActionGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 520 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 4 ? 0.92 : 1.55,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return _AdminActionButton(action: action);
          },
        );
      },
    );
  }
}

class _AdminActionButton extends StatelessWidget {
  final _AdminAction action;

  const _AdminActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon, color: action.color),
            ),
            const SizedBox(height: 10),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
