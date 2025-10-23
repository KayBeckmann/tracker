import 'package:collection/collection.dart';

import '../data/local/app_database.dart';
import 'ledger_models.dart';

List<LedgerAccountSnapshot> buildAccountSnapshots({
  required List<LedgerAccount> accounts,
  required List<LedgerTransaction> transactions,
}) {
  final Map<int, double> balances = {
    for (final account in accounts) account.id: account.initialBalance,
  };
  final Map<int, double> plannedIncome = {
    for (final account in accounts) account.id: 0,
  };
  final Map<int, double> plannedExpense = {
    for (final account in accounts) account.id: 0,
  };

  for (final transaction in transactions) {
    final amount = transaction.amount;
    switch (transaction.transactionKind) {
      case LedgerTransactionKind.income:
        final accountId = transaction.accountId;
        if (accountId == null) {
          continue;
        }
        if (transaction.isPlanned) {
          plannedIncome.update(accountId, (value) => value + amount);
        } else {
          balances.update(
            accountId,
            (value) => value + amount,
            ifAbsent: () => amount,
          );
        }
        break;
      case LedgerTransactionKind.expense:
        final accountId = transaction.accountId;
        if (accountId == null) {
          continue;
        }
        if (transaction.isPlanned) {
          plannedExpense.update(accountId, (value) => value + amount);
        } else {
          balances.update(
            accountId,
            (value) => value - amount,
            ifAbsent: () => -amount,
          );
        }
        break;
      case LedgerTransactionKind.transfer:
        final sourceId = transaction.accountId;
        final targetId = transaction.targetAccountId;
        if (sourceId != null) {
          if (transaction.isPlanned) {
            plannedExpense.update(sourceId, (value) => value + amount);
          } else {
            balances.update(
              sourceId,
              (value) => value - amount,
              ifAbsent: () => -amount,
            );
          }
        }
        if (targetId != null) {
          if (transaction.isPlanned) {
            plannedIncome.update(targetId, (value) => value + amount);
          } else {
            balances.update(
              targetId,
              (value) => value + amount,
              ifAbsent: () => amount,
            );
          }
        }
        break;
      case LedgerTransactionKind.cryptoPurchase:
        final accountId = transaction.accountId;
        if (accountId == null) {
          continue;
        }
        if (transaction.isPlanned) {
          plannedExpense.update(accountId, (value) => value + amount);
        } else {
          balances.update(
            accountId,
            (value) => value - amount,
            ifAbsent: () => -amount,
          );
        }
        break;
    }
  }

  final sortedAccounts = accounts.sorted(
    (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  );

  return sortedAccounts
      .map(
        (account) => LedgerAccountSnapshot(
          account: account,
          actualBalance: balances[account.id] ?? account.initialBalance,
          plannedIncome: plannedIncome[account.id] ?? 0,
          plannedExpense: plannedExpense[account.id] ?? 0,
        ),
      )
      .toList();
}

bool _isWithinBudgetPeriod(LedgerBudget budget, DateTime bookingDate) {
  final date = bookingDate.toUtc();
  switch (budget.periodKind) {
    case LedgerBudgetPeriodKind.monthly:
      if (budget.month == null) {
        return false;
      }
      return date.year == budget.year && date.month == budget.month;
    case LedgerBudgetPeriodKind.quarterly:
      if (budget.month == null) {
        return false;
      }
      final targetQuarter = ((budget.month! - 1) ~/ 3) + 1;
      final currentQuarter = ((date.month - 1) ~/ 3) + 1;
      return date.year == budget.year && currentQuarter == targetQuarter;
    case LedgerBudgetPeriodKind.yearly:
      return date.year == budget.year;
  }
}

List<LedgerBudgetUsage> buildBudgetUsage({
  required List<LedgerBudget> budgets,
  required List<LedgerTransaction> transactions,
  required List<LedgerCategory> categories,
}) {
  final Map<int, LedgerCategory> categoryById = {
    for (final category in categories) category.id: category,
  };
  final Map<int, List<LedgerCategory>> childrenByParent = {};
  for (final category in categories) {
    if (category.parentId == null) {
      continue;
    }
    childrenByParent
        .putIfAbsent(category.parentId!, () => <LedgerCategory>[])
        .add(category);
  }

  LedgerCategoryKind? resolveKind(int categoryId) {
    final category = categoryById[categoryId];
    if (category != null) {
      return category.categoryKind;
    }
    return null;
  }

  final usages = <LedgerBudgetUsage>[];
  for (final budget in budgets) {
    final category = categoryById[budget.categoryId];
    if (category == null) {
      continue;
    }
    final relevantCategoryIds = <int>{budget.categoryId};
    if (category.parentId == null) {
      final children =
          childrenByParent[category.id] ?? const <LedgerCategory>[];
      for (final child in children) {
        relevantCategoryIds.add(child.id);
      }
    }
    double actual = 0;
    double planned = 0;
    for (final transaction in transactions) {
      if (transaction.currencyCode.toUpperCase() !=
          budget.currencyCode.toUpperCase()) {
        continue;
      }
      if (!_isWithinBudgetPeriod(budget, transaction.bookingDate)) {
        continue;
      }
      final LedgerCategoryKind? kind = resolveKind(
        transaction.subcategoryId ?? transaction.categoryId ?? -1,
      );
      if (kind == null) {
        continue;
      }
      if (kind != category.categoryKind) {
        continue;
      }
      final bool matchesCategory =
          (transaction.categoryId != null &&
              relevantCategoryIds.contains(transaction.categoryId!)) ||
          (transaction.subcategoryId != null &&
              relevantCategoryIds.contains(transaction.subcategoryId!));
      if (!matchesCategory) {
        continue;
      }
      final isRelevantTransaction = switch (transaction.transactionKind) {
        LedgerTransactionKind.income =>
          category.categoryKind == LedgerCategoryKind.income,
        LedgerTransactionKind.expense =>
          category.categoryKind == LedgerCategoryKind.expense,
        LedgerTransactionKind.cryptoPurchase =>
          category.categoryKind == LedgerCategoryKind.expense,
        LedgerTransactionKind.transfer => false,
      };
      if (!isRelevantTransaction) {
        continue;
      }
      if (transaction.isPlanned) {
        planned += transaction.amount;
      } else {
        actual += transaction.amount;
      }
    }
    usages.add(
      LedgerBudgetUsage(
        budget: budget,
        actualAmount: actual,
        plannedAmount: planned,
      ),
    );
  }

  return usages
      .sorted((a, b) => a.budget.categoryId.compareTo(b.budget.categoryId))
      .toList();
}

LedgerDashboardSummary buildDashboardSummary({
  required List<LedgerAccountSnapshot> accounts,
}) {
  final Map<String, double> netWorth = {};
  final Map<String, double> plannedIncome = {};
  final Map<String, double> plannedExpense = {};

  for (final snapshot in accounts) {
    final currency = snapshot.account.currencyCode.toUpperCase();
    if (snapshot.account.includeInNetWorth) {
      netWorth.update(
        currency,
        (value) => value + snapshot.actualBalance,
        ifAbsent: () => snapshot.actualBalance,
      );
    }
    if (snapshot.plannedIncome > 0) {
      plannedIncome.update(
        currency,
        (value) => value + snapshot.plannedIncome,
        ifAbsent: () => snapshot.plannedIncome,
      );
    }
    if (snapshot.plannedExpense > 0) {
      plannedExpense.update(
        currency,
        (value) => value + snapshot.plannedExpense,
        ifAbsent: () => snapshot.plannedExpense,
      );
    }
  }

  return LedgerDashboardSummary(
    netWorthByCurrency: netWorth,
    plannedIncomeByCurrency: plannedIncome,
    plannedExpensesByCurrency: plannedExpense,
  );
}

CryptoHoldingSnapshot buildCryptoHoldingSnapshot({
  required LedgerTransaction transaction,
  double? currentUnitPrice,
}) {
  final quantity = transaction.cryptoQuantity ?? 0;
  final purchaseValue = transaction.amount;
  final double? currentValue = currentUnitPrice == null
      ? null
      : quantity * currentUnitPrice;
  return CryptoHoldingSnapshot(
    transaction: transaction,
    currentUnitPrice: currentUnitPrice,
    currentValue: currentValue,
    purchaseValue: purchaseValue,
  );
}
