import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/content_model.dart';
import '../../../services/content_service.dart';
import '../../../services/user_progress_service.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/rating_widget.dart';
import '../../../widgets/tag_chip.dart';
import '../../../screens/meditation_player_screen.dart';

class ContentDetailScreen extends StatefulWidget {
  final String contentId;
  final ContentModel? content;

  const ContentDetailScreen({
    Key? key,
    required this.contentId,
    this.content,
  }) : super(key: key);

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  ContentModel? _content;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadContent();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadContent() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      ContentModel content;
      if (widget.content != null) {
        content = widget.content!;
      } else {
        content = await ContentService.getContentById(widget.contentId);
      }

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _playContent() async {
    if (_content == null) return;

    try {
      // Record session start
      await UserProgressService.recordSession(
        contentId: _content!.id,
        duration: 0, // Will be updated when session ends
        metadata: {
          'action': 'started',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Navigate to meditation player
      Get.to(() => MeditationPlayerScreen(
        content: _content!,
        onSessionComplete: _onSessionComplete,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start session: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onSessionComplete(int duration) async {
    try {
      // Record completed session
      await UserProgressService.recordSession(
        contentId: _content!.id,
        duration: duration,
        metadata: {
          'action': 'completed',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session completed! Great job! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Failed to record session completion: $e');
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareContent() {
    if (_content == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing content...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingWidget()
          : _isError
              ? CustomErrorWidget(
                  message: _errorMessage,
                  onRetry: _loadContent,
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_content == null) {
      return const CustomErrorWidget(
        message: 'Content not found',
        onRetry: null,
      );
    }

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: _content!.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),
              
              // Main Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content Info
                          _buildContentInfo(),
                          SizedBox(height: 24.h),
                          
                          // Action Buttons
                          _buildActionButtons(),
                          SizedBox(height: 24.h),
                          
                          // Description
                          _buildDescription(),
                          SizedBox(height: 24.h),
                          
                          // Tags
                          _buildTags(),
                          SizedBox(height: 24.h),
                          
                          // Statistics
                          _buildStatistics(),
                          SizedBox(height: 24.h),
                          
                          // Related Content
                          _buildRelatedContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _toggleFavorite,
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: _shareContent,
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _content!.categoryDisplayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        
        // Title
        Text(
          _content!.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Subtitle
        Text(
          _content!.subtitle,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Author and Duration
        Row(
          children: [
            Icon(Icons.person, color: Colors.white70, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              _content!.author,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Icon(Icons.access_time, color: Colors.white70, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              _content!.formattedDuration,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
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
        // Play Button
        Expanded(
          child: CustomButton(
            onPressed: _playContent,
            text: 'Start Meditation',
            icon: Icons.play_arrow,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            height: 56.h,
            borderRadius: 16,
          ),
        ),
        SizedBox(width: 12.w),
        
        // Preview Button
        CustomButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preview not available')),
            );
          },
          text: 'Preview',
          icon: Icons.headphones,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          borderColor: Colors.white,
          height: 56.h,
          borderRadius: 16,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          _content!.description,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    if (_content!.tags.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _content!.tags.map((tag) => TagChip(
            label: tag,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Searching for: $tag')),
              );
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rating
          Expanded(
            child: Column(
              children: [
                RatingWidget(rating: _content!.rating),
                SizedBox(height: 4.h),
                Text(
                  '${_content!.rating}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rating',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          
          // Play Count
          Expanded(
            child: Column(
              children: [
                Icon(Icons.play_circle, color: Colors.white, size: 24.sp),
                SizedBox(height: 4.h),
                Text(
                  '${_content!.playCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Plays',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          
          // Duration
          Expanded(
            child: Column(
              children: [
                Icon(Icons.timer, color: Colors.white, size: 24.sp),
                SizedBox(height: 4.h),
                Text(
                  _content!.formattedDuration,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Duration',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You might also like',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: FutureBuilder<List<ContentModel>>(
            future: ContentService.getContentByCategory(_content!.category, limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('No related content'));
              }
              
              final relatedContent = snapshot.data!
                  .where((content) => content.id != _content!.id)
                  .take(3)
                  .toList();
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedContent.length,
                itemBuilder: (context, index) {
                  final content = relatedContent[index];
                  return Container(
                    width: 120.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ContentDetailScreen(
                          contentId: content.id,
                          content: content,
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: content.imageUrl,
                              height: 80.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            content.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
} 