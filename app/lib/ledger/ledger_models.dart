import '../data/local/app_database.dart';

class LedgerAccountSnapshot {
  const LedgerAccountSnapshot({
    required this.account,
    required this.actualBalance,
    required this.plannedIncome,
    required this.plannedExpense,
  });

  final LedgerAccount account;
  final double actualBalance;
  final double plannedIncome;
  final double plannedExpense;

  double get projectedBalance => actualBalance + plannedIncome - plannedExpense;
}

class LedgerBudgetUsage {
  const LedgerBudgetUsage({
    required this.budget,
    required this.actualAmount,
    required this.plannedAmount,
  });

  final LedgerBudget budget;
  final double actualAmount;
  final double plannedAmount;

  double get projectedAmount => actualAmount + plannedAmount;

  double get remaining => budget.amount - actualAmount;
}

class LedgerDashboardSummary {
  const LedgerDashboardSummary({
    required this.netWorthByCurrency,
    required this.plannedIncomeByCurrency,
    required this.plannedExpensesByCurrency,
  });

  final Map<String, double> netWorthByCurrency;
  final Map<String, double> plannedIncomeByCurrency;
  final Map<String, double> plannedExpensesByCurrency;
}

class NetWorthDataPoint {
  const NetWorthDataPoint({
    required this.date,
    required this.netWorthByCurrency,
  });

  final DateTime date;
  final Map<String, double> netWorthByCurrency;
}

class CryptoHoldingSnapshot {
  const CryptoHoldingSnapshot({
    required this.transaction,
    required this.currentUnitPrice,
    required this.currentValue,
    required this.purchaseValue,
  });

  final LedgerTransaction transaction;
  final double? currentUnitPrice;
  final double? currentValue;
  final double purchaseValue;

  double? get profitLoss =>
      currentValue == null ? null : currentValue! - purchaseValue;
}
