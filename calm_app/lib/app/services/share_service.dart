import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/interactive_feedback.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  // Share analytics tracking
  static int _totalShares = 0;
  static Map<String, int> _shareTypeCounts = {};
  static Map<String, int> _contentTypeShares = {};

  // Share options configuration
  static const List<Map<String, dynamic>> _shareOptions = [
    {
      'id': 'whatsapp',
      'title': 'WhatsApp',
      'icon': Icons.chat,
      'color': Color(0xFF25D366),
      'enabled': true,
    },
    {
      'id': 'facebook',
      'title': 'Facebook',
      'icon': Icons.facebook,
      'color': Color(0xFF1877F2),
      'enabled': true,
    },
    {
      'id': 'twitter',
      'title': 'Twitter',
      'icon': Icons.flutter_dash,
      'color': Color(0xFF1DA1F2),
      'enabled': true,
    },
    {
      'id': 'instagram',
      'title': 'Instagram',
      'icon': Icons.camera_alt,
      'color': Color(0xFFE4405F),
      'enabled': true,
    },
    {
      'id': 'telegram',
      'title': 'Telegram',
      'icon': Icons.send,
      'color': Color(0xFF0088CC),
      'enabled': true,
    },
    {
      'id': 'email',
      'title': 'Email',
      'icon': Icons.email,
      'color': Color(0xFFEA4335),
      'enabled': true,
    },
    {
      'id': 'copy_link',
      'title': 'Copy Link',
      'icon': Icons.copy,
      'color': Color(0xFF34A853),
      'enabled': true,
    },
    {
      'id': 'more',
      'title': 'More',
      'icon': Icons.more_horiz,
      'color': Color(0xFF9E9E9E),
      'enabled': true,
    },
  ];

  // Share content types
  static const Map<String, String> _contentTypeMessages = {
    'meditation': 'Check out this amazing meditation session on Calm! 🧘‍♀️✨',
    'sleep': 'This sleep story helped me relax and fall asleep peacefully 😴💤',
    'gratitude': 'Practicing gratitude today with Calm! 🙏 #DailyGratitude',
    'reflection': 'Taking time for self-reflection with Calm 📝✨',
    'breathing': 'This breathing exercise is perfect for stress relief 🌬️💙',
    'music': 'Beautiful calming music from Calm 🎵🎶',
    'content': 'Amazing content from Calm that you should check out! ✨',
    'achievement': 'Just completed my daily mindfulness practice with Calm! 🎉',
    'quote': 'Inspiring quote from Calm that resonated with me today 💭✨',
  };

  // Generate shareable content
  static Map<String, String> generateShareableContent({
    required String contentType,
    required String title,
    String? subtitle,
    String? description,
    String? imageUrl,
    String? customMessage,
    Map<String, dynamic>? additionalData,
  }) {
    final baseUrl = 'https://calm.app/share';
    final contentId = _generateContentId();
    final shareUrl = '$baseUrl/$contentType/$contentId';
    
    final defaultMessage = _contentTypeMessages[contentType] ?? _contentTypeMessages['content']!;
    final message = customMessage ?? defaultMessage;
    
    final shareText = subtitle != null 
        ? '$message\n\n"$title" - $subtitle\n\n$shareUrl'
        : '$message\n\n"$title"\n\n$shareUrl';
    
    final hashtags = _generateHashtags(contentType);
    final fullText = '$shareText\n\n$hashtags';
    
    return {
      'title': title,
      'message': message,
      'shareText': shareText,
      'fullText': fullText,
      'url': shareUrl,
      'hashtags': hashtags,
      'contentType': contentType,
      'contentId': contentId,
    };
  }

  // Show comprehensive share dialog
  static Future<void> showShareDialog({
    required BuildContext context,
    required String contentType,
    required String title,
    String? subtitle,
    String? description,
    String? imageUrl,
    String? customMessage,
    Map<String, dynamic>? additionalData,
    bool showCustomMessage = true,
  }) async {
    HapticFeedbackHelper.mediumImpact();
    
    final shareContent = generateShareableContent(
      contentType: contentType,
      title: title,
      subtitle: subtitle,
      description: description,
      imageUrl: imageUrl,
      customMessage: customMessage,
      additionalData: additionalData,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B4B6F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildShareSheet(context, shareContent, showCustomMessage),
    );
  }

  // Build comprehensive share sheet
  static Widget _buildShareSheet(BuildContext context, Map<String, String> shareContent, bool showCustomMessage) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Content preview
          _buildContentPreview(shareContent),
          SizedBox(height: 20.h),
          
          // Custom message input (if enabled)
          if (showCustomMessage) ...[
            _buildCustomMessageInput(context, shareContent),
            SizedBox(height: 20.h),
          ],
          
          // Share options grid
          Expanded(
            child: _buildShareOptionsGrid(context, shareContent),
          ),
          
          // Analytics info
          _buildAnalyticsInfo(),
        ],
      ),
    );
  }

  // Build content preview
  static Widget _buildContentPreview(Map<String, String> shareContent) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            shareContent['title']!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            shareContent['message']!,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            shareContent['hashtags']!,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Build custom message input
  static Widget _buildCustomMessageInput(BuildContext context, Map<String, String> shareContent) {
    final TextEditingController messageController = TextEditingController(text: shareContent['message']);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Message',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: messageController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Add your personal message...',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
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
              borderSide: const BorderSide(color: Colors.orange),
            ),
          ),
          maxLines: 3,
          onChanged: (value) {
            shareContent['message'] = value;
          },
        ),
      ],
    );
  }

  // Build share options grid
  static Widget _buildShareOptionsGrid(BuildContext context, Map<String, String> shareContent) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: _shareOptions.length,
      itemBuilder: (context, index) {
        final option = _shareOptions[index];
        return _buildShareOption(context, option, shareContent);
      },
    );
  }

  // Build individual share option
  static Widget _buildShareOption(BuildContext context, Map<String, dynamic> option, Map<String, String> shareContent) {
    return GestureDetector(
      onTap: () => _handleShareOption(context, option['id'], shareContent),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: (option['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: option['color'] as Color),
            ),
            child: Icon(
              option['icon'] as IconData,
              color: option['color'] as Color,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            option['title'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Build analytics info
  static Widget _buildAnalyticsInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.analytics, color: Colors.white70, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            'Total shares: $_totalShares',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Handle share option selection
  static void _handleShareOption(BuildContext context, String optionId, Map<String, String> shareContent) {
    HapticFeedbackHelper.lightImpact();
    
    switch (optionId) {
      case 'whatsapp':
        _shareToWhatsApp(shareContent);
        break;
      case 'facebook':
        _shareToFacebook(shareContent);
        break;
      case 'twitter':
        _shareToTwitter(shareContent);
        break;
      case 'instagram':
        _shareToInstagram(shareContent);
        break;
      case 'telegram':
        _shareToTelegram(shareContent);
        break;
      case 'email':
        _shareViaEmail(shareContent);
        break;
      case 'copy_link':
        _copyLinkToClipboard(context, shareContent);
        break;
      case 'more':
        _showMoreOptions(context, shareContent);
        break;
    }
    
    // Track analytics
    _trackShare(optionId, shareContent['contentType']!);
    
    Navigator.pop(context);
  }

  // Share to WhatsApp
  static void _shareToWhatsApp(Map<String, String> shareContent) {
    // Simulate WhatsApp sharing
    _showShareSuccess('WhatsApp', 'Message shared to WhatsApp!');
  }

  // Share to Facebook
  static void _shareToFacebook(Map<String, String> shareContent) {
    // Simulate Facebook sharing
    _showShareSuccess('Facebook', 'Content shared to Facebook!');
  }

  // Share to Twitter
  static void _shareToTwitter(Map<String, String> shareContent) {
    // Simulate Twitter sharing
    _showShareSuccess('Twitter', 'Tweet posted successfully!');
  }

  // Share to Instagram
  static void _shareToInstagram(Map<String, String> shareContent) {
    // Simulate Instagram sharing
    _showShareSuccess('Instagram', 'Story shared to Instagram!');
  }

  // Share to Telegram
  static void _shareToTelegram(Map<String, String> shareContent) {
    // Simulate Telegram sharing
    _showShareSuccess('Telegram', 'Message sent to Telegram!');
  }

  // Share via Email
  static void _shareViaEmail(Map<String, String> shareContent) {
    // Simulate email sharing
    _showShareSuccess('Email', 'Email draft created!');
  }

  // Copy link to clipboard
  static void _copyLinkToClipboard(BuildContext context, Map<String, String> shareContent) {
    Clipboard.setData(ClipboardData(text: shareContent['url']!));
    _showShareSuccess('Copy Link', 'Link copied to clipboard!');
  }

  // Show more options
  static void _showMoreOptions(BuildContext context, Map<String, String> shareContent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B4B6F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMoreOptionsSheet(context, shareContent),
    );
  }

  // Build more options sheet
  static Widget _buildMoreOptionsSheet(BuildContext context, Map<String, String> shareContent) {
    final moreOptions = [
      {'title': 'Save to Photos', 'icon': Icons.save_alt},
      {'title': 'Print', 'icon': Icons.print},
      {'title': 'Add to Calendar', 'icon': Icons.calendar_today},
      {'title': 'Send to Friends', 'icon': Icons.people},
      {'title': 'Add to Notes', 'icon': Icons.note},
      {'title': 'Bookmark', 'icon': Icons.bookmark},
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'More Options',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: moreOptions.length,
            itemBuilder: (context, index) {
              final option = moreOptions[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showShareSuccess(option['title'] as String, '${option['title']} completed!');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        option['icon'] as IconData,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      option['title'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Show share success feedback
  static void _showShareSuccess(String platform, String message) {
    // In a real app, this would show a SnackBar or Toast
    // For now, we'll simulate success feedback
    print('Share Success: $platform - $message');
  }

  // Track share analytics
  static void _trackShare(String shareType, String contentType) {
    _totalShares++;
    _shareTypeCounts[shareType] = (_shareTypeCounts[shareType] ?? 0) + 1;
    _contentTypeShares[contentType] = (_contentTypeShares[contentType] ?? 0) + 1;
    
    // In a real app, this would send analytics to a server
    print('Share Analytics: Type=$shareType, Content=$contentType, Total=$_totalShares');
  }

  // Generate content ID
  static String _generateContentId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Generate hashtags
  static String _generateHashtags(String contentType) {
    final baseHashtags = ['#Calm', '#Mindfulness', '#Wellness'];
    final contentTypeHashtags = {
      'meditation': ['#Meditation', '#InnerPeace'],
      'sleep': ['#Sleep', '#Rest', '#Dreams'],
      'gratitude': ['#Gratitude', '#Thankful', '#Blessed'],
      'reflection': ['#Reflection', '#SelfCare', '#Growth'],
      'breathing': ['#Breathing', '#Calm', '#Relax'],
      'music': ['#CalmMusic', '#Relaxation', '#Peace'],
      'content': ['#CalmContent', '#Wellness'],
      'achievement': ['#Achievement', '#Progress', '#Growth'],
      'quote': ['#Quote', '#Inspiration', '#Motivation'],
    };
    
    final specificHashtags = contentTypeHashtags[contentType] ?? ['#CalmContent'];
    return [...baseHashtags, ...specificHashtags].join(' ');
  }

  // Get share analytics
  static Map<String, dynamic> getShareAnalytics() {
    return {
      'totalShares': _totalShares,
      'shareTypeCounts': _shareTypeCounts,
      'contentTypeShares': _contentTypeShares,
    };
  }

  // Reset analytics (for testing)
  static void resetAnalytics() {
    _totalShares = 0;
    _shareTypeCounts.clear();
    _contentTypeShares.clear();
  }
} 