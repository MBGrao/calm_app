import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../components/ai_assistant_button.dart';
import '../../../data/models/content_model.dart';
import '../../../widgets/category_icon_grid.dart';
import '../../../widgets/premium_card_box.dart';
import '../../../widgets/theme_aware_components.dart';
import '../../../widgets/daily_ai_suggestion.dart';
import '../../../widgets/home_popualar_carousal_card.dart';
import '../../../widgets/floating_particles.dart';
import '../../../widgets/wave_animation.dart';
import '../../../widgets/interactive_feedback.dart';
import 'ai_recommendations_modal.dart';
import 'all_popular_content_screen.dart';
import 'all_recommended_screen.dart';
import 'content_detail_screen.dart';
import 'whispr_mode_screen.dart';
import 'search_screen.dart';

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Enhanced gradient background
          Container(
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
          ),
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 280.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/home_screen/home_top.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 180.h,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.25),
                    ),
                    // Mountain icon
                    Positioned(
                      left: 16.w,
                      top: 65.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        radius: 22,
                        child: const Icon(Icons.terrain,
                            color: Colors.white, size: 26),
                      ),
                    ),
                    // Gift icon
                    Positioned(
                      right: 16.w,
                      top: 60.h,
                      child: Row(
                        children: [
                          // Search button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.withOpacity(0.8),
                                    Colors.blue.withOpacity(0.6),
                                    Colors.blue.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Gift icon
                          Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFDD015),
                                  Color(0xFFBE8926),
                                  Color(0xFFFDD015),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/home_screen/gift.png',
                                height: 26.h,
                                width: 26.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // MeditAi title
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 60.h,
                      child: Center(
                        child: Text(
                          'MeditAi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38.sp,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Daily AI Suggestion
                const DailyAiSuggestion(),
                SizedBox(height: 24.h),
                // Sleep Stories Section
                // Premium banner
                PremiumCardBox(
                   onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AiRecommendationsModal(
                          onClose: () => Navigator.of(context).pop(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 22.h),
                // Greeting
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Good Afternoon,Shehnaz',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),
                // Smart Recommendations
                _buildSmartRecommendations(),
                SizedBox(height: 18.h),
                // Popular on MeditAi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular on MeditAi',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedbackHelper.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllPopularContentScreen(
                                category: 'Popular on MeditAi',
                                content: [
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Calming anxiety',
                                    'subtitle': 'Meditation • 3 minutes',
                                    'tag': 'Music',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Numb Little Bug',
                                    'subtitle': 'Single • Em Beihold',
                                    'tag': 'Music',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Your weekly mixtape',
                                    'subtitle': 'Single • EM weekly',
                                    'tag': 'Podcast',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Numb Little Bug',
                                    'subtitle': 'Single • Em Beihold',
                                    'tag': 'Music',
                                  },
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // Carousel of popular cards
                SizedBox(
                  height: 210.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80',
                        title: 'Calming anxiety',
                        subtitle: 'Meditation • 3 minutes',
                        tag: 'Music',
                      ),
                      const SizedBox(width: 16),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
                        title: 'Numb Little Bug',
                        subtitle: 'Single • Em Beihold',
                      ),
                      const SizedBox(width: 16),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
                        title: 'Your weekly mixtape ',
                        subtitle: 'eingle . EM weekly',
                      ),
                      const SizedBox(width: 16),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                        title: 'Numb Little Bug',
                        subtitle: 'Single • Em Beihold',
                      ),
                    ],
                  ),
                ),
              
                // Divider and second carousel
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended for You',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedbackHelper.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllRecommendedScreen(
                                category: 'Recommended for You',
                                content: [
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Morning Motivation',
                                    'subtitle': 'Podcast • 10 minutes',
                                    'tag': 'Podcast',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Deep Sleep',
                                    'subtitle': 'Sleep • 8 hours',
                                    'tag': 'Sleep',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Nature Sounds',
                                    'subtitle': 'Music • 1 hour',
                                    'tag': 'Music',
                                  },
                                  {
                                    'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                    'title': 'Focus Booster',
                                    'subtitle': 'Meditation • 15 minutes',
                                    'tag': 'Meditation',
                                  },
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 210,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
                        title: 'Morning Motivation',
                        subtitle: 'Podcast • 10 minutes',
                        tag: 'Podcast',
                      ),
                      SizedBox(width: 16.w),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                        title: 'Deep Sleep',
                        subtitle: 'Sleep • 8 hours',
                      ),
                      SizedBox(width: 16.w),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                        title: 'Nature Sounds',
                        subtitle: 'Music • 1 hour',
                        tag: 'Music',
                      ),
                      SizedBox(width: 16.w),
                      PopularCarouselCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                        title: 'Focus Booster',
                        subtitle: 'Meditation • 15 minutes',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                // Large card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedbackHelper.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContentDetailScreen(
                            contentId: 'peace-content-1',
                            content: ContentModel(
                              id: 'peace-content-1',
                              title: 'For Peace',
                              subtitle: 'For people finding inner peace',
                              description: 'A peaceful meditation session for finding inner peace.',
                              imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
                              audioUrl: '',
                              category: 'meditation',
                              tags: ['peace', 'calm'],
                              duration: 600,
                              author: 'Meditation Master',
                              rating: 4.5,
                              playCount: 1200,
                              isPremium: false,
                              createdAt: DateTime.now(),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/icons/home_screen/moon.png',
                                height: 140.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 140.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [Colors.blue, Colors.purple],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            const Positioned(
                              left: 0,
                              right: 0,
                              top: 40,
                              child: Center(
                                child: Text(
                                  'Peace',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          'For Peace',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'For people finding inner peace',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),
                const SizedBox(height: 18),
                // Explore by Content
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Explore by Content',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 12),
                 child: CategoryIconGrid(),
               ),
               SizedBox(height: 20.h),
               
               // Whispr Mode Section
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.record_voice_over,
                           color: Colors.yellow,
                           size: 20.sp,
                         ),
                         SizedBox(width: 8.w),
                         Text(
                           'Whispr Mode',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 12.h),
                     AnimatedButton(
                       onPressed: () {
                         HapticFeedbackHelper.lightImpact();
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (_) => WhisprModeScreen(),
                           ),
                         );
                       },
                       child: Container(
                         padding: EdgeInsets.all(16.w),
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                             colors: [
                               Colors.purple.withOpacity(0.8),
                               Colors.blue.withOpacity(0.8),
                             ],
                           ),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Row(
                           children: [
                             Icon(
                               Icons.mic,
                               color: Colors.white,
                               size: 24.sp,
                             ),
                             SizedBox(width: 12.w),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     'Voice Control',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 16.sp,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   Text(
                                     'Speak to control your meditation',
                                     style: TextStyle(
                                       color: Colors.white70,
                                       fontSize: 12.sp,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             Icon(
                               Icons.arrow_forward_ios,
                               color: Colors.white70,
                               size: 16.sp,
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               
               SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const AIAssistantButton(),
    );
  }

  Widget _buildSmartRecommendations() {
    try {
      // Get personalized recommendations based on user preferences
      final recommendations = _getPersonalizedRecommendations();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                ThemeAwareIcon(
                  Icons.psychology,
                  color: Colors.yellow,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                ThemeAwareText(
                  'Recommended for You',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final content = recommendations[index];
                return AnimatedCard(
                  onTap: () {
                    HapticFeedbackHelper.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentDetailScreen(
                          contentId: content.id,
                          content: content,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 160.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            content.imageUrl,
                            width: 160.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 160.w,
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
                        SizedBox(height: 8.h),
                        Flexible(
                          child: ThemeAwareText(
                            content.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: ThemeAwareText(
                            content.subtitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } catch (e) {
      // Return a simple fallback if recommendations fail
      return Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Center(
          child: Text(
            'Recommendations coming soon...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      );
    }
  }

  List<ContentModel> _getPersonalizedRecommendations() {
    try {
      // Simulate personalized recommendations based on user behavior
      
      // In a real app, this would use ML/AI to generate recommendations
      // For now, we'll simulate by mixing popular and recent content
      final popularContent = ContentRepository.getPopularContent(limit: 4);
      final recentContent = ContentRepository.getRecentContent(limit: 4);
      
      // Mix popular and recent content for variety
      final recommendations = <ContentModel>[];
      for (int i = 0; i < math.min(popularContent.length, recentContent.length); i++) {
        if (i % 2 == 0) {
          recommendations.add(popularContent[i]);
        } else {
          recommendations.add(recentContent[i]);
        }
      }
      
      return recommendations.take(4).toList();
    } catch (e) {
      // Return empty list if repository fails
      return [];
    }
  }
}
