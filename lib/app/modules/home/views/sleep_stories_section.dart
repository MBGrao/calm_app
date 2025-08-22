import 'package:flutter/material.dart';
import 'content_detail_screen.dart';
import '../../../data/models/content_model.dart';
import 'all_content_screen.dart';

class SleepStoriesSection extends StatelessWidget {
  const SleepStoriesSection({Key? key}) : super(key: key);

  // Sample sleep stories data
  final List<Map<String, String>> _sleepStories = const [
    {
      'title': 'Bedtime Stories',
      'duration': '20 min',
      'category': 'Stories',
      'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Nature Sounds',
      'duration': '15 min',
      'category': 'Nature',
      'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Ocean Waves',
      'duration': '25 min',
      'category': 'Ocean',
      'imageUrl': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Deep Sleep',
      'duration': '30 min',
      'category': 'Deep Sleep',
      'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sleep Stories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllContentScreen(
                        category: 'sleep',
                        title: 'Sleep Stories',
                      ),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _sleepStories.length,
            itemBuilder: (context, index) {
              final story = _sleepStories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentDetailScreen(
                          contentId: 'sleep-story-${story['title']!.toLowerCase().replaceAll(' ', '-')}',
                          content: ContentModel(
                            id: 'sleep-story-${story['title']!.toLowerCase().replaceAll(' ', '-')}',
                            title: story['title']!,
                            subtitle: story['duration']!,
                            description: 'Peaceful sleep story for relaxation.',
                            imageUrl: story['imageUrl']!,
                            audioUrl: '',
                            category: story['category']!,
                            tags: ['sleep', story['category']!],
                            duration: 600,
                            author: 'Sleep Guide',
                            rating: 4.5,
                            playCount: 200,
                            isPremium: false,
                            createdAt: DateTime.now(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Story Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            story['imageUrl']!,
                            width: 160,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  story['category']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                story['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                                                  Text(
                                  story['duration']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 