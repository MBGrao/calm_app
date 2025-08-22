import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/content_model.dart';
import 'rating_widget.dart';

class SearchResultCard extends StatefulWidget {
  final ContentModel content;
  final VoidCallback? onTap;
  final bool showPremiumBadge;
  final bool showPlayCount;
  final bool showDuration;
  final bool showRating;

  const SearchResultCard({
    Key? key,
    required this.content,
    this.onTap,
    this.showPremiumBadge = true,
    this.showPlayCount = true,
    this.showDuration = true,
    this.showRating = true,
  }) : super(key: key);

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isPressed 
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: _buildCardContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Image Section
          _buildImageSection(),
          SizedBox(width: 12.w),
          
          // Content Info Section
          Expanded(
            child: _buildContentInfoSection(),
          ),
          
          // Action Section
          _buildActionSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: widget.content.imageUrl,
            width: 80.w,
            height: 80.w,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        
        // Play Button Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.content.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        
        // Subtitle
        Text(
          widget.content.subtitle,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        
        // Meta Information
        Row(
          children: [
            // Rating
            if (widget.showRating) ...[
              RatingWidget(
                rating: widget.content.rating,
                size: 12,
                showText: false,
              ),
              SizedBox(width: 4.w),
              Text(
                '(${widget.content.rating})',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 12.w),
            ],
            
            // Duration
            if (widget.showDuration) ...[
              Icon(
                Icons.access_time,
                color: Colors.white70,
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                widget.content.formattedDuration,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
        
        // Play Count
        if (widget.showPlayCount) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '${widget.content.playCount} plays',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Premium Badge
        if (widget.showPremiumBadge && widget.content.isPremium)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'PREMIUM',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        // Action Buttons
        Column(
          children: [
            IconButton(
              onPressed: () {
                // TODO: Implement bookmark functionality
              },
              icon: const Icon(
                Icons.bookmark_border,
                color: Colors.white70,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Implement share functionality
              },
              icon: const Icon(
                Icons.share,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 