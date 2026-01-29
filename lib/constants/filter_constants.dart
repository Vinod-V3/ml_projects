class FilterOption {
  final String value;
  final String label;

  const FilterOption({
    required this.value,
    required this.label,
  });
}

class AppFilters {
  static const List<FilterOption> projectFilters = [
    FilterOption(value: 'assignedToMe', label: 'assigned_to_me'),
    FilterOption(value: 'discoveredByMe', label: 'discovered_by_me'),
    FilterOption(value: 'createdByMe', label: 'created_by_me'),
  ];
}
