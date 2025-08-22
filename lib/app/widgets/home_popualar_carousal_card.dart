import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/home/views/content_detail_screen.dart';
import '../data/models/content_model.dart';
import '../widgets/interactive_feedback.dart';

class PopularCarouselCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? tag;
  final IconData? icon;
  const PopularCarouselCard({required this.imageUrl, this.icon, required this.title, required this.subtitle, this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: 'popular-${title.toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel(
                id: 'popular-${title.toLowerCase().replaceAll(' ', '-')}',
                title: title,
                subtitle: subtitle,
                description: 'Popular content loved by many users.',
                imageUrl: imageUrl,
                audioUrl: '',
                category: tag ?? 'popular',
                tags: [tag ?? 'popular'],
                duration: 300,
                author: 'Content Creator',
                rating: 4.5,
                playCount: 500,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imageUrl,
                  height: 120.h,
                  width: 190.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120.h,
                      width: 190.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                      ),
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
           SizedBox(height: 10.h),
          Text(
            title,
            style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style:  TextStyle(color: Colors.white70, fontSize: 10.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      ),
    );
  }
} 