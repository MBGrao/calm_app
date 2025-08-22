import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterPanel extends StatefulWidget {
  final String selectedCategory;
  final List<String> selectedTags;
  final int? minDuration;
  final int? maxDuration;
  final bool? isPremium;
  final String sortBy;
  final String sortOrder;
  final Function(String) onCategoryChanged;
  final Function(List<String>) onTagsChanged;
  final Function(int?, int?) onDurationChanged;
  final Function(bool?) onPremiumChanged;
  final Function(String, String) onSortChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const SearchFilterPanel({
    Key? key,
    required this.selectedCategory,
    required this.selectedTags,
    required this.minDuration,
    required this.maxDuration,
    required this.isPremium,
    required this.sortBy,
    required this.sortOrder,
    required this.onCategoryChanged,
    required this.onTagsChanged,
    required this.onDurationChanged,
    required this.onPremiumChanged,
    required this.onSortChanged,
    required this.onReset,
    required this.onApply,
  }) : super(key: key);

  @override
  State<SearchFilterPanel> createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _minDurationController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Initialize duration controllers
    if (widget.minDuration != null) {
      _minDurationController.text = widget.minDuration.toString();
    }
    if (widget.maxDuration != null) {
      _maxDurationController.text = widget.maxDuration.toString();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _minDurationController.dispose();
    _maxDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * 100, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 16.h),
                  _buildCategoryFilter(),
                  SizedBox(height: 16.h),
                  _buildDurationFilter(),
                  SizedBox(height: 16.h),
                  _buildPremiumFilter(),
                  SizedBox(height: 16.h),
                  _buildSortOptions(),
                  SizedBox(height: 20.h),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.filter_list,
          color: Colors.white,
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          'Search Filters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: widget.onReset,
          child: Text(
            'Reset',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: widget.selectedCategory.isEmpty ? null : widget.selectedCategory,
          onChanged: (value) {
            widget.onCategoryChanged(value ?? '');
          },
          decoration: InputDecoration(
            labelText: 'Select Category',
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
          ),
          dropdownColor: const Color(0xFF1B4B6F),
          style: const TextStyle(color: Colors.white),
          items: [
            const DropdownMenuItem(value: '', child: Text('All Categories')),
            const DropdownMenuItem(value: 'meditation', child: Text('Meditation')),
            const DropdownMenuItem(value: 'sleep', child: Text('Sleep Stories')),
            const DropdownMenuItem(value: 'breathing', child: Text('Breathing')),
            const DropdownMenuItem(value: 'relaxation', child: Text('Relaxation')),
            const DropdownMenuItem(value: 'music', child: Text('Music')),
            const DropdownMenuItem(value: 'nature', child: Text('Nature')),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration (minutes)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minDurationController,
                decoration: InputDecoration(
                  labelText: 'Min',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  final min = int.tryParse(value);
                  widget.onDurationChanged(min, widget.maxDuration);
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                controller: _maxDurationController,
                decoration: InputDecoration(
                  labelText: 'Max',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  final max = int.tryParse(value);
                  widget.onDurationChanged(widget.minDuration, max);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Checkbox(
              value: widget.isPremium,
              onChanged: (value) {
                widget.onPremiumChanged(value);
              },
                             fillColor: WidgetStateProperty.resolveWith(
                 (states) => states.contains(WidgetState.selected)
                     ? Colors.blue
                     : Colors.white.withOpacity(0.2),
               ),
              checkColor: Colors.white,
            ),
            Text(
              'Premium Content Only',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: widget.sortBy,
                onChanged: (value) {
                  if (value != null) {
                    widget.onSortChanged(value, widget.sortOrder);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Sort Field',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                dropdownColor: const Color(0xFF1B4B6F),
                style: const TextStyle(color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                  const DropdownMenuItem(value: 'title', child: Text('Title')),
                  const DropdownMenuItem(value: 'duration', child: Text('Duration')),
                  const DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  const DropdownMenuItem(value: 'playCount', child: Text('Popularity')),
                  const DropdownMenuItem(value: 'createdAt', child: Text('Date')),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: widget.sortOrder,
                onChanged: (value) {
                  if (value != null) {
                    widget.onSortChanged(widget.sortBy, value);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Order',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                dropdownColor: const Color(0xFF1B4B6F),
                style: const TextStyle(color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'ASC', child: Text('Ascending')),
                  const DropdownMenuItem(value: 'DESC', child: Text('Descending')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 