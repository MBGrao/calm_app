import 'package:calm_app/app/widgets/feature_card_with_circle_image.dart';
import 'package:calm_app/app/widgets/premium_card_box.dart';
import 'package:calm_app/app/modules/home/views/all_sleep_stories_screen.dart';
import 'package:calm_app/app/modules/home/views/content_detail_screen.dart';
import 'package:calm_app/app/widgets/interactive_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'category_screen.dart';
import 'package:calm_app/app/widgets/floating_particles.dart';
import 'package:calm_app/app/widgets/wave_animation.dart';
import '../../../data/models/content_model.dart';

class SleepScreen extends StatelessWidget {
  SleepScreen({Key? key}) : super(key: key);

  // Dummy data for sections
  final List<Map<String, String>> featured = [
    {
      "img": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      "title": "Calming anxiety",
      "subtitle": "Meditation",
      "avatar": "https://randomuser.me/api/portraits/men/1.jpg",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
      "title": "Numb Little Bug",
      "subtitle": "Amber",
      "avatar": "https://randomuser.me/api/portraits/women/2.jpg",
    },
  ];

  final List<Map<String, String>> springInBloom = [
    {
      "img": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      "title": "Calming anxiety",
      "subtitle": "Meditation",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
      "title": "Numb Little Bug",
      "subtitle": "Amber",
    },
  ];

  final List<Map<String, String>> popularSleepStories = [
    {
      "img": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      "title": "Calming anxiety",
      "subtitle": "Meditation",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
      "title": "Numb Little Bug",
      "subtitle": "Amber",
    },
    {
      "img": "https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80",
      "title": "Peaceful Mind",
      "subtitle": "Instrumental",
    },
    {
      "img": "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80",
      "title": "Ocean Waves",
      "subtitle": "Nature",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
      "title": "Deep Sleep",
      "subtitle": "Sleep Music",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> collageImages = [
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80",
    ];

    return Scaffold(
      // backgroundColor: const Color(0xFF1B4B6F),
      body: Container(
         decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B517E),
                Color(0xFF0D3550),
                Color(0xFF32366F),
                Color(0xFF1B517E),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        child: Stack(
          children: [
            // Floating particles
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: FloatingParticles(),
              ),
            ),
            // Wave animations
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Opacity(
                opacity: 0.2,
                child: WaveAnimation(),
              ),
            ),
            // Main content
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Title & Subtitle
                   Text(
                    "Sleep",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 8.h),
                   Text(
                    "smoothing bed time stories to help you fall into deep and natural sleep",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.sp,
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // Filter Chips
                  SizedBox(
                    height: 40, // More compact height
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _chip(context, "sleep stories", selected: true),
                        SizedBox(width: 12),
                        _chip(context, "All"),
                        SizedBox(width: 12),
                        _chip(context, "Meditation"),
                        SizedBox(width: 12),
                        _chip(context, "Tools"),
                        SizedBox(width: 12),
                        _chip(context, "Music"),
                      ],
                    ),
                  ),
                   SizedBox(height: 16.h),
        
                  // Premium Card
                PremiumCardBox(),

                   SizedBox(height: 24.h),
        
                  // Featured Section
                  _sectionHeader(context, "Featured"),
                   SizedBox(height: 12.h),
              
                  const SizedBox(height: 32),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                  FeatureCardWithCircleImage(img: "https://randomuser.me/api/portraits/men/1.jpg", avatar: "https://randomuser.me/api/portraits/men/1.jpg", title: "title", subtitle: "subtitle"),
                  FeatureCardWithCircleImage(img: "https://randomuser.me/api/portraits/men/1.jpg", avatar: "https://randomuser.me/api/portraits/men/1.jpg", title: "title", subtitle: "subtitle"),
                  FeatureCardWithCircleImage(img: "https://randomuser.me/api/portraits/men/1.jpg", avatar: "https://randomuser.me/api/portraits/men/1.jpg", title: "title", subtitle: "subtitle"),


                      ],
                    ),
                  ),
                  // Spring in Bloom Section
                  _sectionHeader(context, "Spring in Bloom"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: springInBloom.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        final item = springInBloom[i];
                        return _storyCard(context, item);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
        
                  // Popular Sleep Stories Section
                  _sectionHeader(context, "Popular Sleep Stories"),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: popularSleepStories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _collageCard(context, collageImages),
                            const SizedBox(height: 6),
                            const Text("Calming anxiety", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const Text("Meditation", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        );
                      }
                      final item = popularSleepStories[i];
                      return _storyCard(context, item, showDownloadIcon: false);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:  TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
         GestureDetector(
           onTap: () {
             HapticFeedbackHelper.lightImpact();
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (_) => AllSleepStoriesScreen(
                   category: title,
                   content: [
                     {
                       'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                       'title': 'Calming anxiety',
                       'subtitle': 'Meditation',
                       'tag': 'Meditation',
                     },
                     {
                       'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                       'title': 'Numb Little Bug',
                       'subtitle': 'Amber',
                       'tag': 'Music',
                     },
                     {
                       'imageUrl': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
                       'title': 'Peaceful Mind',
                       'subtitle': 'Instrumental',
                       'tag': 'Music',
                     },
                     {
                       'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
                       'title': 'Ocean Waves',
                       'subtitle': 'Nature',
                       'tag': 'Nature',
                     },
                     {
                       'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                       'title': 'Deep Sleep',
                       'subtitle': 'Sleep Music',
                       'tag': 'Sleep',
                     },
                   ],
                 ),
               ),
             );
           },
           child: Text(
             "See All",
             style: TextStyle(
               color: Colors.white54,
               fontSize: 14.sp,
               fontWeight: FontWeight.w500,
             ),
           ),
         ),
      ],
    );
  }

  // Filter Chip Widget
  Widget _chip(BuildContext context, String label, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> CategoryScreen(category: label, isSelected: selected,)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD6D6D6) : const Color(0xFF183B5B),
          borderRadius: BorderRadius.circular(30),
          border: selected
              ? null
              : Border.all(
                  color: const Color(0x66FFFFFF), // white with opacity
                  width: 3.w,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF757575) : Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }



  // Story Card Widget (for Spring in Bloom & Popular Sleep Stories)
  Widget _storyCard(BuildContext context, Map<String, String> item, {bool showDownloadIcon = true}) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: 'sleep-${item["title"]?.toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel(
                id: 'sleep-${item["title"]?.toLowerCase().replaceAll(' ', '-')}',
                title: item["title"]!,
                subtitle: item["subtitle"]!,
                description: 'Peaceful sleep content to help you relax.',
                imageUrl: item["img"]!,
                audioUrl: '',
                category: 'sleep',
                tags: ['sleep', 'relaxation'],
                duration: 600,
                author: 'Sleep Guide',
                rating: 4.5,
                playCount: 300,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: Container(
      child: Stack(
        children: [
           ClipRRect(
           borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/icons/home_screen/moon.png',
              width: 200.w,
              height: 120.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                  ),
                ),
                Text(
                  item["subtitle"]!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                  ),
                ),
              ],
            ),
          ),
          // Download icon (bottom left)
          if (showDownloadIcon)
            Positioned(
              bottom: 60.h,
              left: 8.w,
              child: Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 18.sp,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
        ],
      ),
      ),
    );
  }

  // Collage Card Widget
  Widget _collageCard(BuildContext context, List<String> images) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: 'sleep-collage-1',
              content: ContentModel(
                id: 'sleep-collage-1',
                title: 'Calming anxiety',
                subtitle: 'Meditation',
                description: 'Featured sleep content for relaxation.',
                imageUrl: images.isNotEmpty ? images[0] : 'assets/icons/home_screen/moon.png',
                audioUrl: '',
                category: 'sleep',
                tags: ['sleep', 'featured'],
                duration: 600,
                author: 'Sleep Guide',
                rating: 4.6,
                playCount: 500,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: images.length,
            itemBuilder: (context, i) => Image.asset(
              'assets/icons/home_screen/moon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

