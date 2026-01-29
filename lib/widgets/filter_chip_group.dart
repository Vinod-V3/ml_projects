import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ml_projects/constants/filter_constants.dart';

class FilterChipGroup extends StatefulWidget {
  final List<FilterOption> filters;
  final String? selectedValue;
  final Function(String?) onFilterSelected;

  const FilterChipGroup({
    super.key,
    required this.filters,
    this.selectedValue,
    required this.onFilterSelected,
  });

  @override
  State<FilterChipGroup> createState() => _FilterChipGroupState();
}

class _FilterChipGroupState extends State<FilterChipGroup> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: widget.filters.map((filter) {
          final isSelected = _selectedValue == filter.value;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter.label.tr()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedValue = selected ? filter.value : null;
                });
                widget.onFilterSelected(_selectedValue);
              },
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              backgroundColor: Colors.grey.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }
}
