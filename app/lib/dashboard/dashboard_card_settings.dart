/// Size options for dashboard cards.
enum DashboardCardSize {
  compact,
  normal,
  large,
}

/// Time period filter for dashboard cards.
enum DashboardCardPeriod {
  today,
  week,
  month,
  all,
}

/// Sort order for items in dashboard cards.
enum DashboardCardSortOrder {
  newest,
  oldest,
  alphabetical,
  priority,
}

/// Configuration for a single dashboard card.
class DashboardCardConfig {
  const DashboardCardConfig({
    this.visible = true,
    this.size = DashboardCardSize.normal,
    this.itemCount = 3,
    this.period = DashboardCardPeriod.all,
    this.sortOrder = DashboardCardSortOrder.newest,
  });

  final bool visible;
  final DashboardCardSize size;
  final int itemCount;
  final DashboardCardPeriod period;
  final DashboardCardSortOrder sortOrder;

  DashboardCardConfig copyWith({
    bool? visible,
    DashboardCardSize? size,
    int? itemCount,
    DashboardCardPeriod? period,
    DashboardCardSortOrder? sortOrder,
  }) {
    return DashboardCardConfig(
      visible: visible ?? this.visible,
      size: size ?? this.size,
      itemCount: itemCount ?? this.itemCount,
      period: period ?? this.period,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'visible': visible,
      'size': size.name,
      'itemCount': itemCount,
      'period': period.name,
      'sortOrder': sortOrder.name,
    };
  }

  factory DashboardCardConfig.fromJson(Map<String, dynamic> json) {
    return DashboardCardConfig(
      visible: json['visible'] as bool? ?? true,
      size: DashboardCardSize.values.firstWhere(
        (e) => e.name == json['size'],
        orElse: () => DashboardCardSize.normal,
      ),
      itemCount: json['itemCount'] as int? ?? 3,
      period: DashboardCardPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => DashboardCardPeriod.all,
      ),
      sortOrder: DashboardCardSortOrder.values.firstWhere(
        (e) => e.name == json['sortOrder'],
        orElse: () => DashboardCardSortOrder.newest,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardCardConfig &&
        other.visible == visible &&
        other.size == size &&
        other.itemCount == itemCount &&
        other.period == period &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return Object.hash(visible, size, itemCount, period, sortOrder);
  }
}

/// Available setting types for dashboard cards.
enum DashboardCardSettingType {
  visible,
  size,
  itemCount,
  period,
  sortOrder,
}
