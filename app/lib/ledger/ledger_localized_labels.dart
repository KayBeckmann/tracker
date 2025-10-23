import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

String ledgerAccountKindLabel(AppLocalizations loc, LedgerAccountKind kind) {
  return switch (kind) {
    LedgerAccountKind.cash => loc.ledgerAccountKindCash,
    LedgerAccountKind.bankAccount => loc.ledgerAccountKindBank,
    LedgerAccountKind.depot => loc.ledgerAccountKindDepot,
    LedgerAccountKind.asset => loc.ledgerAccountKindAsset,
    LedgerAccountKind.crypto => loc.ledgerAccountKindCrypto,
  };
}

String ledgerCategoryKindLabel(AppLocalizations loc, LedgerCategoryKind kind) {
  return switch (kind) {
    LedgerCategoryKind.income => loc.ledgerCategoryKindIncome,
    LedgerCategoryKind.expense => loc.ledgerCategoryKindExpense,
  };
}

String ledgerTransactionKindLabel(
  AppLocalizations loc,
  LedgerTransactionKind kind,
) {
  return switch (kind) {
    LedgerTransactionKind.income => loc.ledgerTransactionKindIncome,
    LedgerTransactionKind.expense => loc.ledgerTransactionKindExpense,
    LedgerTransactionKind.transfer => loc.ledgerTransactionKindTransfer,
    LedgerTransactionKind.cryptoPurchase =>
      loc.ledgerTransactionKindCryptoPurchase,
  };
}

String ledgerBudgetPeriodLabel(
  AppLocalizations loc,
  LedgerBudgetPeriodKind kind,
) {
  return switch (kind) {
    LedgerBudgetPeriodKind.monthly => loc.ledgerBudgetPeriodMonthly,
    LedgerBudgetPeriodKind.quarterly => loc.ledgerBudgetPeriodQuarterly,
    LedgerBudgetPeriodKind.yearly => loc.ledgerBudgetPeriodYearly,
  };
}

String ledgerRecurringIntervalLabel(
  AppLocalizations loc,
  LedgerRecurringIntervalKind kind,
) {
  return switch (kind) {
    LedgerRecurringIntervalKind.daily => loc.ledgerRecurringIntervalDaily,
    LedgerRecurringIntervalKind.weekly => loc.ledgerRecurringIntervalWeekly,
    LedgerRecurringIntervalKind.monthly => loc.ledgerRecurringIntervalMonthly,
    LedgerRecurringIntervalKind.quarterly =>
      loc.ledgerRecurringIntervalQuarterly,
    LedgerRecurringIntervalKind.yearly => loc.ledgerRecurringIntervalYearly,
    LedgerRecurringIntervalKind.custom => loc.ledgerRecurringIntervalCustom,
  };
}
