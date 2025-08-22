import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/home/views/content_detail_screen.dart';
import '../data/models/content_model.dart';
import '../widgets/interactive_feedback.dart';

class FeatureCardWithCircleImage extends StatelessWidget {
  final String img;
  final String avatar;
  final String title;
  final String subtitle;

  const FeatureCardWithCircleImage({
    Key? key,
    required this.img,
    required this.avatar,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: 'feature-${title.toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel(
                id: 'feature-${title.toLowerCase().replaceAll(' ', '-')}',
                title: title,
                subtitle: subtitle,
                description: 'Featured content for you.',
                imageUrl: img,
                audioUrl: '',
                category: 'featured',
                tags: ['featured'],
                duration: 300,
                author: 'Content Creator',
                rating: 4.4,
                playCount: 200,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 220.w,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              img,
              width: 200.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
