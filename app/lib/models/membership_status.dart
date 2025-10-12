import 'package:app/l10n/generated/app_localizations.dart';

class MembershipStatus {
  const MembershipStatus({
    required this.membershipLevel,
    required this.syncEnabled,
    required this.priceMonthly,
    required this.priceYearly,
    this.membershipExpiresAt,
    this.lastPaymentMethod,
    this.syncRetentionUntil,
  });

  factory MembershipStatus.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return MembershipStatus(
      membershipLevel: (json['membership_level'] as String?) ?? 'none',
      membershipExpiresAt: parseDate(json['membership_expires_at']),
      syncEnabled: json['sync_enabled'] as bool? ?? false,
      lastPaymentMethod: json['last_payment_method'] as String?,
      syncRetentionUntil: parseDate(json['sync_retention_until']),
      priceMonthly: (json['price_monthly'] as num?)?.toDouble() ?? 1.0,
      priceYearly: (json['price_yearly'] as num?)?.toDouble() ?? 10.0,
    );
  }

  final String membershipLevel;
  final DateTime? membershipExpiresAt;
  final bool syncEnabled;
  final String? lastPaymentMethod;
  final DateTime? syncRetentionUntil;
  final double priceMonthly;
  final double priceYearly;

  bool get isActive =>
      membershipLevel != 'none' &&
      membershipExpiresAt != null &&
      membershipExpiresAt!.isAfter(DateTime.now());

  String planLabel(AppLocalizations loc) {
    switch (membershipLevel) {
      case 'monthly':
        return loc.membershipPlanMonthlyLabel;
      case 'yearly':
        return loc.membershipPlanYearlyLabel;
      default:
        return loc.membershipPlanNoneLabel;
    }
  }

  String? paymentMethodLabel(AppLocalizations loc) {
    switch (lastPaymentMethod) {
      case 'paypal':
        return loc.membershipPaymentMethodPaypal;
      case 'bitcoin':
        return loc.membershipPaymentMethodBitcoin;
      default:
        return null;
    }
  }
}
