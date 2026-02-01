import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'crypto_price_service.dart';
import 'ledger_account_form.dart';
import 'ledger_budget_form.dart';
import 'ledger_category_form.dart';
import 'ledger_localized_labels.dart';
import 'ledger_models.dart';
import 'ledger_recurring_form.dart';
import 'ledger_transaction_form.dart';
import 'ledger_utils.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage>
    with SingleTickerProviderStateMixin {
  late final CryptoPriceService _cryptoService;

  @override
  void initState() {
    super.initState();
    _cryptoService = CryptoPriceService(database: widget.database);
  }

  @override
  void dispose() {
    _cryptoService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: const Icon(Icons.dashboard_outlined),
                text: loc.ledgerTabDashboard,
              ),
              Tab(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                text: loc.ledgerTabAccounts,
              ),
              Tab(
                icon: const Icon(Icons.swap_horiz),
                text: loc.ledgerTabTransactions,
              ),
              Tab(
                icon: const Icon(Icons.pie_chart),
                text: loc.ledgerTabBudgets,
              ),
              Tab(
                icon: const Icon(Icons.schedule),
                text: loc.ledgerTabRecurring,
              ),
              Tab(
                icon: const Icon(Icons.category),
                text: loc.ledgerTabCategories,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                LedgerDashboardTab(database: widget.database),
                LedgerAccountsTab(database: widget.database),
                LedgerTransactionsTab(
                  database: widget.database,
                  cryptoService: _cryptoService,
                ),
                LedgerBudgetsTab(database: widget.database),
                LedgerRecurringTab(database: widget.database),
                LedgerCategoriesTab(database: widget.database),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _DashboardPeriod { days30, days90, year1, allTime }

class LedgerDashboardTab extends StatefulWidget {
  const LedgerDashboardTab({super.key, required this.database});

  final AppDatabase database;

  @override
  State<LedgerDashboardTab> createState() => _LedgerDashboardTabState();
}

class _LedgerDashboardTabState extends State<LedgerDashboardTab> {
  _DashboardPeriod _period = _DashboardPeriod.days90;

  int get _periodDays => switch (_period) {
        _DashboardPeriod.days30 => 30,
        _DashboardPeriod.days90 => 90,
        _DashboardPeriod.year1 => 365,
        _DashboardPeriod.allTime => 365 * 10,
      };

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder<List<LedgerAccount>>(
      stream: widget.database.watchLedgerAccounts(),
      builder: (context, accountSnapshot) {
        if (!accountSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final accounts = accountSnapshot.data!;
        if (accounts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                loc.ledgerDashboardNoAccounts,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return StreamBuilder<List<LedgerTransaction>>(
          stream: widget.database.watchLedgerTransactions(),
          builder: (context, transactionSnapshot) {
            if (!transactionSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final transactions = transactionSnapshot.data!;
            final snapshots = buildAccountSnapshots(
              accounts: accounts,
              transactions: transactions,
            );
            final summary = buildDashboardSummary(accounts: snapshots);
            final history = buildNetWorthHistory(
              accounts: accounts,
              transactions: transactions,
              periodDays: _periodDays,
            );
            return _DashboardContent(
              summary: summary,
              history: history,
              period: _period,
              onPeriodChanged: (period) {
                setState(() {
                  _period = period;
                });
              },
            );
          },
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
    required this.history,
    required this.period,
    required this.onPeriodChanged,
  });

  final LedgerDashboardSummary summary;
  final List<NetWorthDataPoint> history;
  final _DashboardPeriod period;
  final ValueChanged<_DashboardPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Net Worth Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.ledgerDashboardNetWorthTitle,
                  style: theme.textTheme.titleMedium,
                ),
                if (summary.netWorthByCurrency.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(loc.ledgerDashboardNoNetWorth),
                  )
                else
                  ...summary.netWorthByCurrency.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${numberFormat.format(entry.value)} ${entry.key}',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Net Worth Chart Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.ledgerDashboardNetWorthChart,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SegmentedButton<_DashboardPeriod>(
                  segments: [
                    ButtonSegment(
                      value: _DashboardPeriod.days30,
                      label: Text(loc.ledgerDashboardPeriod30Days),
                    ),
                    ButtonSegment(
                      value: _DashboardPeriod.days90,
                      label: Text(loc.ledgerDashboardPeriod90Days),
                    ),
                    ButtonSegment(
                      value: _DashboardPeriod.year1,
                      label: Text(loc.ledgerDashboardPeriod1Year),
                    ),
                    ButtonSegment(
                      value: _DashboardPeriod.allTime,
                      label: Text(loc.ledgerDashboardPeriodAllTime),
                    ),
                  ],
                  selected: {period},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      onPeriodChanged(selection.first);
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (history.isEmpty ||
                    history.every(
                      (p) => p.netWorthByCurrency.values.every((v) => v == 0),
                    ))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text(loc.ledgerDashboardNoData)),
                  )
                else
                  _NetWorthChart(history: history),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NetWorthChart extends StatelessWidget {
  const _NetWorthChart({required this.history});

  final List<NetWorthDataPoint> history;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final dateFormat = DateFormat.Md(loc.localeName);

    // Get all currencies
    final currencies = <String>{};
    for (final point in history) {
      currencies.addAll(point.netWorthByCurrency.keys);
    }

    // Build chart data for each currency
    final lineData = <LineChartBarData>[];
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    var colorIndex = 0;
    double maxY = 0;
    double minY = 0;

    for (final currency in currencies) {
      final spots = <FlSpot>[];
      for (var i = 0; i < history.length; i++) {
        final value = history[i].netWorthByCurrency[currency] ?? 0;
        spots.add(FlSpot(i.toDouble(), value));
        if (value > maxY) maxY = value;
        if (value < minY) minY = value;
      }

      lineData.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colors[colorIndex % colors.length],
          barWidth: 3,
          dotData: const FlDotData(show: false),
        ),
      );
      colorIndex++;
    }

    // Add padding to Y axis
    final yRange = maxY - minY;
    final yPadding = yRange * 0.1;
    final resolvedMinY = minY - yPadding;
    final resolvedMaxY = maxY + yPadding;

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: resolvedMinY,
          maxY: resolvedMaxY,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.9),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.spotIndex;
                  final date = history[index].date;
                  final currency = currencies.elementAt(spot.barIndex);
                  final value = spot.y;
                  return LineTooltipItem(
                    '${dateFormat.format(date)}\n${numberFormat.format(value)} $currency',
                    theme.textTheme.bodyMedium!,
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, _) {
                  return Text(
                    numberFormat.format(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (history.length / 4).ceilToDouble(),
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= history.length) {
                    return const SizedBox.shrink();
                  }
                  final date = history[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      dateFormat.format(date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: lineData,
        ),
      ),
    );
  }
}

class LedgerAccountsTab extends StatefulWidget {
  const LedgerAccountsTab({super.key, required this.database});

  final AppDatabase database;

  @override
  State<LedgerAccountsTab> createState() => _LedgerAccountsTabState();
}

class _LedgerAccountsTabState extends State<LedgerAccountsTab> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder<List<LedgerAccount>>(
      stream: widget.database.watchLedgerAccounts(),
      builder: (context, accountSnapshot) {
        final accounts = accountSnapshot.data ?? const <LedgerAccount>[];
        return StreamBuilder<List<LedgerTransaction>>(
          stream: widget.database.watchLedgerTransactions().map(
            (rows) =>
                rows.sorted((a, b) => b.bookingDate.compareTo(a.bookingDate)),
          ),
          builder: (context, transactionSnapshot) {
            final transactions =
                transactionSnapshot.data ?? const <LedgerTransaction>[];
            final snapshots = buildAccountSnapshots(
              accounts: accounts,
              transactions: transactions,
            );
            final summary = buildDashboardSummary(accounts: snapshots);
            if (accounts.isEmpty) {
              return _EmptyLedgerAccountsHint(onCreateAccount: _createAccount);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final entry in summary.netWorthByCurrency.entries)
                      Chip(
                        avatar: const Icon(Icons.savings, size: 18),
                        label: Text(
                          '${entry.key} ${entry.value.toStringAsFixed(2)}',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _createAccount,
                    icon: const Icon(Icons.add),
                    label: Text(loc.ledgerAccountCreateButton),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: snapshots.length,
                    itemBuilder: (context, index) {
                      final snapshot = snapshots[index];
                      return _LedgerAccountCard(
                        snapshot: snapshot,
                        onEdit: () => _editAccount(snapshot.account),
                        onDelete: () => _deleteAccount(snapshot.account),
                        onToggleInclude: (value) =>
                            widget.database.setLedgerAccountIncludeInNetWorth(
                              id: snapshot.account.id,
                              includeInNetWorth: value,
                            ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _createAccount() async {
    final loc = AppLocalizations.of(context);
    final result = await showLedgerAccountFormDialog(context: context);
    if (result == null) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      await widget.database.createLedgerAccount(
        name: result.name,
        accountKind: result.accountKind,
        currencyCode: result.currencyCode,
        includeInNetWorth: result.includeInNetWorth,
        initialBalance: result.initialBalance,
        isDefault: result.isDefault,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.ledgerAccountCreateSuccess(result.name))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _editAccount(LedgerAccount account) async {
    final loc = AppLocalizations.of(context);
    final result = await showLedgerAccountFormDialog(
      context: context,
      existing: account,
    );
    if (result == null) {
      return;
    }
    final updated = account.copyWith(
      name: result.name,
      accountKind: result.accountKind,
      currencyCode: result.currencyCode,
      includeInNetWorth: result.includeInNetWorth,
      initialBalance: result.initialBalance,
      isDefault: result.isDefault,
    );
    if (result.isDefault && !account.isDefault) {
      await widget.database.setLedgerAccountDefault(
        id: account.id,
        isDefault: true,
      );
    } else if (!result.isDefault && account.isDefault) {
      await widget.database.setLedgerAccountDefault(
        id: account.id,
        isDefault: false,
      );
    }
    await widget.database.updateLedgerAccount(updated);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.ledgerAccountUpdateSuccess(result.name))),
    );
  }

  Future<void> _deleteAccount(LedgerAccount account) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.ledgerAccountDeleteTitle),
        content: Text(loc.ledgerAccountDeleteMessage(account.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.deleteLedgerAccount(account.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.ledgerAccountDeleteSuccess(account.name))),
    );
  }
}

class _LedgerAccountCard extends StatelessWidget {
  const _LedgerAccountCard({
    required this.snapshot,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleInclude,
  });

  final LedgerAccountSnapshot snapshot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleInclude;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final plannedIncome = snapshot.plannedIncome;
    final plannedExpense = snapshot.plannedExpense;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          snapshot.account.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (snapshot.account.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            loc.ledgerAccountDefaultBadge,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(loc.commonDelete),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${ledgerAccountKindLabel(loc, snapshot.account.accountKind)} • ${snapshot.account.currencyCode}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              loc.ledgerAccountActualBalance(
                numberFormat.format(snapshot.actualBalance),
                snapshot.account.currencyCode,
              ),
              style: theme.textTheme.titleLarge,
            ),
            if (plannedIncome > 0 || plannedExpense > 0) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (plannedIncome > 0)
                    Chip(
                      avatar: const Icon(Icons.trending_up, size: 18),
                      label: Text(
                        loc.ledgerAccountPlannedIncome(
                          numberFormat.format(plannedIncome),
                          snapshot.account.currencyCode,
                        ),
                      ),
                    ),
                  if (plannedExpense > 0)
                    Chip(
                      avatar: const Icon(Icons.trending_down, size: 18),
                      label: Text(
                        loc.ledgerAccountPlannedExpense(
                          numberFormat.format(plannedExpense),
                          snapshot.account.currencyCode,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: snapshot.account.includeInNetWorth,
              onChanged: onToggleInclude,
              title: Text(loc.ledgerAccountIncludeInNetWorthLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLedgerAccountsHint extends StatelessWidget {
  const _EmptyLedgerAccountsHint({required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              loc.ledgerAccountEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              loc.ledgerAccountEmptyDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateAccount,
              icon: const Icon(Icons.add),
              label: Text(loc.ledgerAccountCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerTransactionsTab extends StatefulWidget {
  const LedgerTransactionsTab({
    super.key,
    required this.database,
    required this.cryptoService,
  });

  final AppDatabase database;
  final CryptoPriceService cryptoService;

  @override
  State<LedgerTransactionsTab> createState() => _LedgerTransactionsTabState();
}

enum _TransactionStatusFilter { all, executed, planned }

class _LedgerTransactionsTabState extends State<LedgerTransactionsTab> {
  LedgerTransactionKind? _selectedKind;
  _TransactionStatusFilter _statusFilter = _TransactionStatusFilter.all;
  final Map<String, Future<double?>> _priceFutures = {};

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder<List<LedgerTransaction>>(
      stream: widget.database.watchLedgerTransactions().map(
        (rows) => rows.sorted((a, b) => b.bookingDate.compareTo(a.bookingDate)),
      ),
      builder: (context, transactionSnapshot) {
        final transactions =
            transactionSnapshot.data ?? const <LedgerTransaction>[];
        return StreamBuilder<List<LedgerAccount>>(
          stream: widget.database.watchLedgerAccounts(),
          builder: (context, accountSnapshot) {
            final accounts = accountSnapshot.data ?? const <LedgerAccount>[];
            return StreamBuilder<List<LedgerCategory>>(
              stream: widget.database.watchAllLedgerCategories(),
              builder: (context, categorySnapshot) {
                final categories =
                    categorySnapshot.data ?? const <LedgerCategory>[];
                final filtered = _applyFilters(transactions);
                return Column(
                  children: [
                    _TransactionFilters(
                      selectedKind: _selectedKind,
                      onKindChanged: (kind) {
                        setState(() {
                          _selectedKind = kind;
                        });
                      },
                      statusFilter: _statusFilter,
                      onStatusChanged: (filter) {
                        setState(() {
                          _statusFilter = filter;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: () =>
                            _createTransaction(accounts, categories),
                        icon: const Icon(Icons.add),
                        label: Text(loc.ledgerTransactionCreateButton),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? _EmptyTransactionsHint(
                              onCreate: () =>
                                  _createTransaction(accounts, categories),
                            )
                          : ListView.separated(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final transaction = filtered[index];
                                final account = transaction.accountId == null
                                    ? null
                                    : accounts.firstWhereOrNull(
                                        (acc) =>
                                            acc.id == transaction.accountId,
                                      );
                                final targetAccount =
                                    transaction.targetAccountId == null
                                    ? null
                                    : accounts.firstWhereOrNull(
                                        (acc) =>
                                            acc.id ==
                                            transaction.targetAccountId,
                                      );
                                final category = transaction.categoryId == null
                                    ? null
                                    : categories.firstWhereOrNull(
                                        (cat) =>
                                            cat.id == transaction.categoryId,
                                      );
                                final subcategory =
                                    transaction.subcategoryId == null
                                    ? null
                                    : categories.firstWhereOrNull(
                                        (cat) =>
                                            cat.id == transaction.subcategoryId,
                                      );
                                return _LedgerTransactionTile(
                                  transaction: transaction,
                                  account: account,
                                  targetAccount: targetAccount,
                                  category: category,
                                  subcategory: subcategory,
                                  onEdit: () => _editTransaction(
                                    transaction,
                                    accounts,
                                    categories,
                                  ),
                                  onDelete: () =>
                                      _deleteTransaction(transaction),
                                  onMarkExecuted: transaction.isPlanned
                                      ? () => _markExecuted(transaction)
                                      : null,
                                  priceFutureBuilder:
                                      transaction.transactionKind ==
                                          LedgerTransactionKind.cryptoPurchase
                                      ? _priceFuture(
                                          symbol:
                                              transaction.cryptoSymbol ?? '',
                                          currencyCode:
                                              transaction.currencyCode,
                                        )
                                      : null,
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  List<LedgerTransaction> _applyFilters(List<LedgerTransaction> transactions) {
    return transactions.where((tx) {
      if (_selectedKind != null && tx.transactionKind != _selectedKind) {
        return false;
      }
      return switch (_statusFilter) {
        _TransactionStatusFilter.all => true,
        _TransactionStatusFilter.executed => !tx.isPlanned,
        _TransactionStatusFilter.planned => tx.isPlanned,
      };
    }).toList();
  }

  Future<double?> _priceFuture({
    required String symbol,
    required String currencyCode,
  }) {
    final key = '${symbol.toUpperCase()}_${currencyCode.toUpperCase()}';
    return _priceFutures.putIfAbsent(
      key,
      () => widget.cryptoService.getCurrentPrice(
        symbol: symbol,
        vsCurrency: currencyCode,
      ),
    );
  }

  Future<void> _createTransaction(
    List<LedgerAccount> accounts,
    List<LedgerCategory> categories,
  ) async {
    if (accounts.isEmpty) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.ledgerTransactionNoAccountsWarning)),
      );
      return;
    }
    final result = await showLedgerTransactionFormDialog(
      context: context,
      accounts: accounts,
      categories: categories,
    );
    if (result == null) {
      return;
    }
    await widget.database.insertLedgerTransaction(
      transactionKind: result.transactionKind,
      amount: result.amount,
      currencyCode: result.currencyCode,
      bookingDate: result.bookingDate,
      isPlanned: result.isPlanned,
      accountId: result.accountId,
      targetAccountId: result.targetAccountId,
      categoryId: result.categoryId,
      subcategoryId: result.subcategoryId,
      description: result.description,
      cryptoSymbol: result.cryptoSymbol,
      cryptoQuantity: result.cryptoQuantity,
      pricePerUnit: result.pricePerUnit,
    );
  }

  Future<void> _editTransaction(
    LedgerTransaction transaction,
    List<LedgerAccount> accounts,
    List<LedgerCategory> categories,
  ) async {
    final result = await showLedgerTransactionFormDialog(
      context: context,
      existing: transaction,
      accounts: accounts,
      categories: categories,
    );
    if (result == null) {
      return;
    }
    final updated = transaction.copyWith(
      transactionKind: result.transactionKind,
      amount: result.amount,
      currencyCode: result.currencyCode,
      bookingDate: result.bookingDate.toUtc(),
      isPlanned: result.isPlanned,
      description: result.description,
      accountId: Value(result.accountId),
      targetAccountId: Value(result.targetAccountId),
      categoryId: Value(result.categoryId),
      subcategoryId: Value(result.subcategoryId),
      cryptoSymbol: Value(result.cryptoSymbol),
      cryptoQuantity: Value(result.cryptoQuantity),
      pricePerUnit: Value(result.pricePerUnit),
    );
    await widget.database.updateLedgerTransaction(updated);
  }

  Future<void> _deleteTransaction(LedgerTransaction transaction) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.ledgerTransactionDeleteTitle),
        content: Text(loc.ledgerTransactionDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.database.deleteLedgerTransaction(transaction.id);
    }
  }

  Future<void> _markExecuted(LedgerTransaction transaction) async {
    final updated = transaction.copyWith(isPlanned: false);
    await widget.database.updateLedgerTransaction(updated);
  }
}

class _TransactionFilters extends StatelessWidget {
  const _TransactionFilters({
    required this.selectedKind,
    required this.onKindChanged,
    required this.statusFilter,
    required this.onStatusChanged,
  });

  final LedgerTransactionKind? selectedKind;
  final ValueChanged<LedgerTransactionKind?> onKindChanged;
  final _TransactionStatusFilter statusFilter;
  final ValueChanged<_TransactionStatusFilter> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<LedgerTransactionKind?>(
            value: selectedKind,
            decoration: InputDecoration(
              labelText: loc.ledgerTransactionFilterType,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(loc.ledgerTransactionFilterAll),
              ),
              ...LedgerTransactionKind.values.map(
                (kind) => DropdownMenuItem(
                  value: kind,
                  child: Text(ledgerTransactionKindLabel(loc, kind)),
                ),
              ),
            ],
            onChanged: onKindChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<_TransactionStatusFilter>(
            value: statusFilter,
            decoration: InputDecoration(
              labelText: loc.ledgerTransactionFilterStatus,
            ),
            items: [
              DropdownMenuItem(
                value: _TransactionStatusFilter.all,
                child: Text(loc.ledgerTransactionFilterAllStatuses),
              ),
              DropdownMenuItem(
                value: _TransactionStatusFilter.executed,
                child: Text(loc.ledgerTransactionFilterExecuted),
              ),
              DropdownMenuItem(
                value: _TransactionStatusFilter.planned,
                child: Text(loc.ledgerTransactionFilterPlanned),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onStatusChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _LedgerTransactionTile extends StatelessWidget {
  const _LedgerTransactionTile({
    required this.transaction,
    required this.account,
    required this.targetAccount,
    required this.category,
    required this.subcategory,
    required this.onEdit,
    required this.onDelete,
    this.onMarkExecuted,
    this.priceFutureBuilder,
  });

  final LedgerTransaction transaction;
  final LedgerAccount? account;
  final LedgerAccount? targetAccount;
  final LedgerCategory? category;
  final LedgerCategory? subcategory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMarkExecuted;
  final Future<double?>? priceFutureBuilder;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final amountText =
        '${transaction.currencyCode} ${numberFormat.format(transaction.amount)}';
    final dateString = DateFormat.yMMMd(
      loc.localeName,
    ).format(transaction.bookingDate.toLocal());
    final subtitleParts = <String>[];
    if (account != null) {
      subtitleParts.add(account!.name);
    }
    if (targetAccount != null) {
      subtitleParts.add('→ ${targetAccount!.name}');
    }
    if (category != null) {
      subtitleParts.add(category!.name);
    }
    if (subcategory != null) {
      subtitleParts.add(subcategory!.name);
    }
    final subtitle = [
      dateString,
      if (subtitleParts.isNotEmpty) subtitleParts.join(' • '),
    ].join(' · ');

    return Card(
      child: ListTile(
        leading: Icon(_iconForTransaction(transaction.transactionKind)),
        title: Text(
          transaction.description.isEmpty
              ? ledgerTransactionKindLabel(loc, transaction.transactionKind)
              : transaction.description,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            if (transaction.isPlanned)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  loc.ledgerTransactionStatusPlanned,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            if (transaction.transactionKind ==
                    LedgerTransactionKind.cryptoPurchase &&
                transaction.cryptoQuantity != null &&
                transaction.pricePerUnit != null &&
                priceFutureBuilder != null)
              FutureBuilder<double?>(
                future: priceFutureBuilder,
                builder: (context, snapshot) {
                  final currentPrice = snapshot.data;
                  final holding = buildCryptoHoldingSnapshot(
                    transaction: transaction,
                    currentUnitPrice: currentPrice,
                  );
                  if (holding.currentUnitPrice == null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        loc.ledgerCryptoCurrentPriceLoading(
                          transaction.cryptoSymbol ?? '',
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }
                  final profit = holding.profitLoss ?? 0;
                  final profitText = numberFormat.format(profit.abs());
                  final profitLabel = profit >= 0
                      ? loc.ledgerCryptoProfit(
                          profitText,
                          transaction.currencyCode,
                        )
                      : loc.ledgerCryptoLoss(
                          profitText,
                          transaction.currencyCode,
                        );
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${loc.ledgerCryptoCurrentPriceLabel(holding.currentUnitPrice!.toStringAsFixed(2), transaction.currencyCode, transaction.cryptoSymbol ?? '')} · $profitLabel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: profit >= 0
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(amountText, style: theme.textTheme.titleMedium),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                  case 'execute':
                    onMarkExecuted?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
                if (onMarkExecuted != null)
                  PopupMenuItem(
                    value: 'execute',
                    child: Text(loc.ledgerTransactionMarkExecuted),
                  ),
                PopupMenuItem(value: 'delete', child: Text(loc.commonDelete)),
              ],
            ),
          ],
        ),
        onTap: onEdit,
        onLongPress: onDelete,
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  IconData _iconForTransaction(LedgerTransactionKind kind) {
    return switch (kind) {
      LedgerTransactionKind.income => Icons.arrow_downward,
      LedgerTransactionKind.expense => Icons.arrow_upward,
      LedgerTransactionKind.transfer => Icons.swap_horiz,
      LedgerTransactionKind.cryptoPurchase => Icons.currency_bitcoin,
    };
  }
}

class _EmptyTransactionsHint extends StatelessWidget {
  const _EmptyTransactionsHint({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              loc.ledgerTransactionEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              loc.ledgerTransactionEmptyDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(loc.ledgerTransactionCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerBudgetsTab extends StatelessWidget {
  const LedgerBudgetsTab({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LedgerBudget>>(
      stream: database.watchLedgerBudgets(),
      builder: (context, budgetSnapshot) {
        final budgets = budgetSnapshot.data ?? const <LedgerBudget>[];
        return StreamBuilder<List<LedgerCategory>>(
          stream: database.watchAllLedgerCategories(),
          builder: (context, categorySnapshot) {
            final categories =
                categorySnapshot.data ?? const <LedgerCategory>[];
            return StreamBuilder<List<LedgerTransaction>>(
              stream: database.watchLedgerTransactions().map(
                (rows) => rows.sorted(
                  (a, b) => b.bookingDate.compareTo(a.bookingDate),
                ),
              ),
              builder: (context, transactionSnapshot) {
                final transactions =
                    transactionSnapshot.data ?? const <LedgerTransaction>[];
                return _LedgerBudgetList(
                  database: database,
                  budgets: budgets,
                  categories: categories,
                  transactions: transactions,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _LedgerBudgetList extends StatefulWidget {
  const _LedgerBudgetList({
    required this.database,
    required this.budgets,
    required this.categories,
    required this.transactions,
  });

  final AppDatabase database;
  final List<LedgerBudget> budgets;
  final List<LedgerCategory> categories;
  final List<LedgerTransaction> transactions;

  @override
  State<_LedgerBudgetList> createState() => _LedgerBudgetListState();
}

class _LedgerBudgetListState extends State<_LedgerBudgetList> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final usages = buildBudgetUsage(
      budgets: widget.budgets,
      transactions: widget.transactions,
      categories: widget.categories,
    );
    final theme = Theme.of(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _createBudget,
            icon: const Icon(Icons.add),
            label: Text(loc.ledgerBudgetCreateButton),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: usages.isEmpty
              ? _EmptyBudgetsHint(onCreate: _createBudget)
              : ListView.separated(
                  itemCount: usages.length,
                  itemBuilder: (context, index) {
                    final usage = usages[index];
                    final category = widget.categories.firstWhereOrNull(
                      (cat) => cat.id == usage.budget.categoryId,
                    );
                    final name =
                        category?.name ?? loc.ledgerBudgetUnknownCategory;
                    final progress = usage.budget.amount == 0
                        ? 0.0
                        : (usage.actualAmount / usage.budget.amount)
                              .clamp(0, 1)
                              .toDouble();
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'edit':
                                        _editBudget(usage.budget);
                                        break;
                                      case 'delete':
                                        _deleteBudget(usage.budget);
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(loc.commonEdit),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(loc.commonDelete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatBudgetPeriod(loc, usage.budget),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(value: progress),
                            const SizedBox(height: 12),
                            Text(
                              loc.ledgerBudgetUsageSummary(
                                usage.actualAmount.toStringAsFixed(2),
                                usage.budget.amount.toStringAsFixed(2),
                                usage.budget.currencyCode,
                              ),
                              style: theme.textTheme.bodyMedium,
                            ),
                            if (usage.plannedAmount > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  loc.ledgerBudgetPlannedAmount(
                                    usage.plannedAmount.toStringAsFixed(2),
                                    usage.budget.currencyCode,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                ),
        ),
      ],
    );
  }

  String _formatBudgetPeriod(AppLocalizations loc, LedgerBudget budget) {
    switch (budget.periodKind) {
      case LedgerBudgetPeriodKind.monthly:
        if (budget.month == null) {
          return '${loc.ledgerBudgetPeriodMonthly} ${budget.year}';
        }
        final date = DateTime(budget.year, budget.month!);
        final monthName = DateFormat.MMMM(loc.localeName).format(date);
        return '$monthName ${budget.year}';
      case LedgerBudgetPeriodKind.quarterly:
        final month = budget.month ?? 1;
        final quarter = ((month - 1) ~/ 3) + 1;
        return loc.ledgerBudgetQuarterName(quarter, budget.year);
      case LedgerBudgetPeriodKind.yearly:
        return loc.ledgerBudgetYearName(budget.year);
    }
  }

  Future<void> _createBudget() async {
    final result = await showLedgerBudgetFormDialog(
      context: context,
      categories: widget.categories,
    );
    if (result == null) {
      return;
    }
    await widget.database.upsertLedgerBudget(
      categoryId: result.categoryId,
      periodKind: result.periodKind,
      year: result.year,
      month: result.month,
      amount: result.amount,
      currencyCode: result.currencyCode,
    );
  }

  Future<void> _editBudget(LedgerBudget budget) async {
    final result = await showLedgerBudgetFormDialog(
      context: context,
      existing: budget,
      categories: widget.categories,
    );
    if (result == null) {
      return;
    }
    await widget.database.upsertLedgerBudget(
      categoryId: result.categoryId,
      periodKind: result.periodKind,
      year: result.year,
      month: result.month,
      amount: result.amount,
      currencyCode: result.currencyCode,
    );
  }

  Future<void> _deleteBudget(LedgerBudget budget) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.ledgerBudgetDeleteTitle),
        content: Text(loc.ledgerBudgetDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.database.deleteLedgerBudget(budget.id);
    }
  }
}

class _EmptyBudgetsHint extends StatelessWidget {
  const _EmptyBudgetsHint({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              loc.ledgerBudgetEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(loc.ledgerBudgetEmptyDescription, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(loc.ledgerBudgetCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerRecurringTab extends StatelessWidget {
  const LedgerRecurringTab({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LedgerRecurringTransaction>>(
      stream: database.watchLedgerRecurringTransactions(),
      builder: (context, snapshot) {
        final recurring = snapshot.data ?? const <LedgerRecurringTransaction>[];
        return StreamBuilder<List<LedgerAccount>>(
          stream: database.watchLedgerAccounts(),
          builder: (context, accountSnapshot) {
            final accounts = accountSnapshot.data ?? const <LedgerAccount>[];
            return StreamBuilder<List<LedgerCategory>>(
              stream: database.watchAllLedgerCategories(),
              builder: (context, categorySnapshot) {
                final categories =
                    categorySnapshot.data ?? const <LedgerCategory>[];
                return _LedgerRecurringList(
                  database: database,
                  recurring: recurring,
                  accounts: accounts,
                  categories: categories,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _LedgerRecurringList extends StatefulWidget {
  const _LedgerRecurringList({
    required this.database,
    required this.recurring,
    required this.accounts,
    required this.categories,
  });

  final AppDatabase database;
  final List<LedgerRecurringTransaction> recurring;
  final List<LedgerAccount> accounts;
  final List<LedgerCategory> categories;

  @override
  State<_LedgerRecurringList> createState() => _LedgerRecurringListState();
}

class _LedgerRecurringListState extends State<_LedgerRecurringList> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _createRecurring,
            icon: const Icon(Icons.add),
            label: Text(loc.ledgerRecurringCreateButton),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: widget.recurring.isEmpty
              ? _EmptyRecurringHint(onCreate: _createRecurring)
              : ListView.separated(
                  itemCount: widget.recurring.length,
                  itemBuilder: (context, index) {
                    final entry = widget.recurring[index];
                    final account = entry.accountId == null
                        ? null
                        : widget.accounts.firstWhereOrNull(
                            (acc) => acc.id == entry.accountId,
                          );
                    final targetAccount = entry.targetAccountId == null
                        ? null
                        : widget.accounts.firstWhereOrNull(
                            (acc) => acc.id == entry.targetAccountId,
                          );
                    final category = entry.categoryId == null
                        ? null
                        : widget.categories.firstWhereOrNull(
                            (cat) => cat.id == entry.categoryId,
                          );
                    final subcategory = entry.subcategoryId == null
                        ? null
                        : widget.categories.firstWhereOrNull(
                            (cat) => cat.id == entry.subcategoryId,
                          );
                    final subtitleParts = <String>[];
                    if (account != null) {
                      subtitleParts.add(account.name);
                    }
                    if (targetAccount != null) {
                      subtitleParts.add('→ ${targetAccount.name}');
                    }
                    if (category != null) {
                      subtitleParts.add(category.name);
                    }
                    if (subcategory != null) {
                      subtitleParts.add(subcategory.name);
                    }
                    final subtitle = subtitleParts.join(' • ');
                    final nextDate = DateFormat.yMMMd(
                      loc.localeName,
                    ).format(entry.nextOccurrence.toLocal());
                    return Card(
                      child: ListTile(
                        leading: Icon(_iconForKind(entry.transactionKind)),
                        title: Text(entry.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (subtitle.isNotEmpty) Text(subtitle),
                            Text(
                              loc.ledgerRecurringNextOccurrenceLabel(nextDate),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${entry.currencyCode} ${entry.amount.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium,
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'apply':
                                    _applyRecurring(entry);
                                    break;
                                  case 'edit':
                                    _editRecurring(entry);
                                    break;
                                  case 'delete':
                                    _deleteRecurring(entry);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'apply',
                                  child: Text(loc.ledgerRecurringApplyNow),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(loc.commonEdit),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(loc.commonDelete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                ),
        ),
      ],
    );
  }

  IconData _iconForKind(LedgerTransactionKind kind) {
    return switch (kind) {
      LedgerTransactionKind.income => Icons.trending_down,
      LedgerTransactionKind.expense => Icons.trending_up,
      LedgerTransactionKind.transfer => Icons.autorenew,
      LedgerTransactionKind.cryptoPurchase => Icons.currency_bitcoin,
    };
  }

  Future<void> _createRecurring() async {
    final result = await showLedgerRecurringFormDialog(
      context: context,
      accounts: widget.accounts,
      categories: widget.categories,
    );
    if (result == null) {
      return;
    }
    await widget.database.createLedgerRecurringTransaction(
      name: result.name,
      transactionKind: result.transactionKind,
      amount: result.amount,
      currencyCode: result.currencyCode,
      startedAt: DateTime.now(),
      nextOccurrence: result.nextOccurrence,
      intervalKind: result.intervalKind,
      intervalCount: result.intervalCount,
      accountId: result.accountId,
      targetAccountId: result.targetAccountId,
      categoryId: result.categoryId,
      subcategoryId: result.subcategoryId,
      autoApply: result.autoApply,
      metadataJson: result.metadataJson ?? '{}',
    );
  }

  Future<void> _editRecurring(LedgerRecurringTransaction entry) async {
    final result = await showLedgerRecurringFormDialog(
      context: context,
      existing: entry,
      accounts: widget.accounts,
      categories: widget.categories,
    );
    if (result == null) {
      return;
    }
    final updated = entry.copyWith(
      name: result.name,
      transactionKind: result.transactionKind,
      amount: result.amount,
      currencyCode: result.currencyCode,
      intervalKind: result.intervalKind,
      intervalCount: result.intervalCount,
      nextOccurrence: result.nextOccurrence.toUtc(),
      accountId: Value(result.accountId),
      targetAccountId: Value(result.targetAccountId),
      categoryId: Value(result.categoryId),
      subcategoryId: Value(result.subcategoryId),
      autoApply: result.autoApply,
      metadataJson: result.metadataJson ?? '{}',
    );
    await widget.database.updateLedgerRecurringTransaction(updated);
  }

  Future<void> _deleteRecurring(LedgerRecurringTransaction entry) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.ledgerRecurringDeleteTitle),
        content: Text(loc.ledgerRecurringDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.database.deleteLedgerRecurringTransaction(entry.id);
    }
  }

  Future<void> _applyRecurring(LedgerRecurringTransaction entry) async {
    await widget.database.applyRecurringTransaction(recurring: entry);
  }
}

class _EmptyRecurringHint extends StatelessWidget {
  const _EmptyRecurringHint({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              loc.ledgerRecurringEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              loc.ledgerRecurringEmptyDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(loc.ledgerRecurringCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerCategoriesTab extends StatelessWidget {
  const LedgerCategoriesTab({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LedgerCategory>>(
      stream: database.watchAllLedgerCategories(includeArchived: true),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? const <LedgerCategory>[];
        return _LedgerCategoryManager(
          database: database,
          categories: categories,
        );
      },
    );
  }
}

class _LedgerCategoryManager extends StatefulWidget {
  const _LedgerCategoryManager({
    required this.database,
    required this.categories,
  });

  final AppDatabase database;
  final List<LedgerCategory> categories;

  @override
  State<_LedgerCategoryManager> createState() => _LedgerCategoryManagerState();
}

class _LedgerCategoryManagerState extends State<_LedgerCategoryManager> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final incomeCategories = widget.categories
        .where(
          (cat) =>
              cat.categoryKind == LedgerCategoryKind.income &&
              cat.parentId == null,
        )
        .toList();
    final expenseCategories = widget.categories
        .where(
          (cat) =>
              cat.categoryKind == LedgerCategoryKind.expense &&
              cat.parentId == null,
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _CategorySection(
          title: loc.ledgerCategoryIncomeSection,
          categories: incomeCategories,
          allCategories: widget.categories,
          onCreate: () => _createCategory(kind: LedgerCategoryKind.income),
          onCreateSub: (parent) =>
              _createCategory(kind: parent.categoryKind, parent: parent),
          onEdit: _editCategory,
          onDelete: _deleteCategory,
        ),
        const SizedBox(height: 16),
        _CategorySection(
          title: loc.ledgerCategoryExpenseSection,
          categories: expenseCategories,
          allCategories: widget.categories,
          onCreate: () => _createCategory(kind: LedgerCategoryKind.expense),
          onCreateSub: (parent) =>
              _createCategory(kind: parent.categoryKind, parent: parent),
          onEdit: _editCategory,
          onDelete: _deleteCategory,
        ),
      ],
    );
  }

  Future<void> _createCategory({
    required LedgerCategoryKind kind,
    LedgerCategory? parent,
  }) async {
    final categories = widget.categories;
    final result = await showLedgerCategoryFormDialog(
      context: context,
      categories: categories,
      parent: parent,
      initialKind: parent?.categoryKind ?? kind,
    );
    if (result == null) {
      return;
    }
    await widget.database.createLedgerCategory(
      name: result.name,
      categoryKind: result.categoryKind,
      parentId: result.parentId,
    );
  }

  Future<void> _editCategory(LedgerCategory category) async {
    final result = await showLedgerCategoryFormDialog(
      context: context,
      existing: category,
      categories: widget.categories,
    );
    if (result == null) {
      return;
    }
    final updated = category.copyWith(
      name: result.name,
      categoryKind: result.categoryKind,
      parentId: Value(result.parentId),
      isArchived: result.archived,
    );
    await widget.database.updateLedgerCategory(updated);
  }

  Future<void> _deleteCategory(LedgerCategory category) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.ledgerCategoryDeleteTitle),
        content: Text(loc.ledgerCategoryDeleteMessage(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.database.deleteLedgerCategory(category.id);
    }
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.categories,
    required this.allCategories,
    required this.onCreate,
    required this.onCreateSub,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final List<LedgerCategory> categories;
  final List<LedgerCategory> allCategories;
  final VoidCallback onCreate;
  final ValueChanged<LedgerCategory> onCreateSub;
  final ValueChanged<LedgerCategory> onEdit;
  final ValueChanged<LedgerCategory> onDelete;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
                FilledButton.tonalIcon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add),
                  label: Text(loc.ledgerCategoryCreateButton),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (categories.isEmpty)
              Text(
                loc.ledgerCategoryEmptySection,
                style: theme.textTheme.bodyMedium,
              )
            else
              Column(
                children: categories.map((category) {
                  final children = allCategories
                      .where((item) => item.parentId == category.id)
                      .toList();
                  return _CategoryTile(
                    category: category,
                    subcategories: children,
                    onCreateSub: onCreateSub,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.subcategories,
    required this.onCreateSub,
    required this.onEdit,
    required this.onDelete,
  });

  final LedgerCategory category;
  final List<LedgerCategory> subcategories;
  final ValueChanged<LedgerCategory> onCreateSub;
  final ValueChanged<LedgerCategory> onEdit;
  final ValueChanged<LedgerCategory> onDelete;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final titleStyle = category.isArchived
        ? theme.textTheme.titleMedium?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: theme.disabledColor,
          )
        : theme.textTheme.titleMedium;

    return ExpansionTile(
      title: Text(category.name, style: titleStyle),
      subtitle: Text(
        category.isArchived
            ? loc.ledgerCategoryArchivedLabel
            : loc.ledgerCategoryActiveLabel,
        style: theme.textTheme.bodySmall,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'add':
              onCreateSub(category);
              break;
            case 'edit':
              onEdit(category);
              break;
            case 'delete':
              onDelete(category);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'add',
            child: Text(loc.ledgerCategoryCreateSubButton),
          ),
          PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
          PopupMenuItem(value: 'delete', child: Text(loc.commonDelete)),
        ],
      ),
      children: [
        if (subcategories.isEmpty)
          ListTile(
            title: Text(
              loc.ledgerCategoryNoSubcategories,
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          ...subcategories.map(
            (subcategory) => ListTile(
              title: Text(
                subcategory.name,
                style: subcategory.isArchived
                    ? theme.textTheme.bodyLarge?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      )
                    : theme.textTheme.bodyLarge,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit(subcategory);
                      break;
                    case 'delete':
                      onDelete(subcategory);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
                  PopupMenuItem(value: 'delete', child: Text(loc.commonDelete)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
