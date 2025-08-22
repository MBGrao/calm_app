import 'dart:ui';
import 'package:flutter/material.dart';
import 'content_detail_screen.dart';
import '../../../data/models/content_model.dart';

class AiRecommendationsModal extends StatefulWidget {
  final VoidCallback onClose;
  const AiRecommendationsModal({Key? key, required this.onClose}) : super(key: key);

  @override
  State<AiRecommendationsModal> createState() => _AiRecommendationsModalState();
}

class _AiRecommendationsModalState extends State<AiRecommendationsModal> {

  // Add music list here
  final List<Map<String, String>> musicList = const [
    {
      "img": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=120&q=80",
      "title": "Calming anxiety",
      "subtitle": "Meditation",
      "avatarUrl": "https://randomuser.me/api/portraits/men/1.jpg",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=120&q=80",
      "title": "Numb Little Bug",
      "subtitle": "Amber",
      "avatarUrl": "https://randomuser.me/api/portraits/women/2.jpg",
    },
    {
      "img": "https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=120&q=80",
      "title": "Peaceful Mind",
      "subtitle": "Instrumental",
      "avatarUrl": "https://randomuser.me/api/portraits/men/3.jpg",
    },
    {
      "img": "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=120&q=80",
      "title": "Ocean Waves",
      "subtitle": "Nature",
      "avatarUrl": "https://randomuser.me/api/portraits/women/4.jpg",
    },
    {
      "img": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=120&q=80",
      "title": "Deep Sleep",
      "subtitle": "Sleep Music",
      "avatarUrl": "https://randomuser.me/api/portraits/men/5.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.15),
      child: Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 32),
                          onPressed: widget.onClose,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // MeditAi title and subtitle
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.bolt, color: Colors.yellow, size: 32),
                              SizedBox(width: 8),
                              Text(
                                "MeditAi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '"Your personalized peace, powered by AI."',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.bolt, color: Colors.yellow, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Suggested by Medit for you',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Recommendations List
                          ...List.generate(5, (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ContentDetailScreen(
                                    contentId: 'ai-recommendation-${index + 1}',
                                    content: ContentModel(
                                      id: 'ai-recommendation-${index + 1}',
                                      title: 'AI Recommended Content ${index + 1}',
                                      subtitle: 'Personalized for you',
                                      description: 'AI-powered content recommendation based on your preferences.',
                                      imageUrl: [
                                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                                        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                        'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
                                        'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
                                        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                      ][index],
                                      audioUrl: '',
                                      category: 'ai_recommendation',
                                      tags: ['ai', 'personalized'],
                                      duration: 240,
                                      author: 'AI Assistant',
                                      rating: 4.5,
                                      playCount: 100,
                                      isPremium: false,
                                      createdAt: DateTime.now(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF223A5E),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        [
                                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                                          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                          'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
                                          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
                                          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
                                        ][index],
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Icon(
                                        Icons.download_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Album • 4 min", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                      const Text("Piano by presence", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                      const Text("Sweet aroma", style: TextStyle(color: Colors.white54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ),
                          )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              onPressed: () {
                                // Simulate refresh by showing a snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Refreshing recommendations...'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // In a real app, this would call an API to get new recommendations
                              },
                              child: const Text('Refresh Recommendations'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Personalize Your Recommendations",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          EmojiDropdown(),
                          const SizedBox(height: 24),
                          const Text(
                            "You seemed calm yesterday,\nwant to continue with sleep music?",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(musicList.length, (index) {
                                final music = musicList[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: index == musicList.length - 1 ? 0 : 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ContentDetailScreen(
                                            contentId: 'music-${music["title"]!.toLowerCase().replaceAll(' ', '-')}',
                                            content: ContentModel(
                                              id: 'music-${music["title"]!.toLowerCase().replaceAll(' ', '-')}',
                                              title: music["title"]!,
                                              subtitle: music["subtitle"]!,
                                              description: 'AI recommended music for your mood.',
                                              imageUrl: music["img"]!,
                                              audioUrl: '',
                                              category: 'music',
                                              tags: ['ai', 'music', 'recommended'],
                                              duration: 180,
                                              author: music["subtitle"]!,
                                              rating: 4.3,
                                              playCount: 500,
                                              isPremium: false,
                                              createdAt: DateTime.now(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: _musicCard(
                                      img: music["img"]!,
                                      title: music["title"]!,
                                      subtitle: music["subtitle"]!,
                                      avatarUrl: music["avatarUrl"]!,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _musicCard({
    required String img,
    required String title,
    required String subtitle,
    required String avatarUrl,
  }) {
    return Container(
      width: 180,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(16),
      //   color: Colors.white10,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              img,
              width: 180,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiDropdown extends StatefulWidget {
  const EmojiDropdown({Key? key}) : super(key: key);

  @override
  State<EmojiDropdown> createState() => _EmojiDropdownState();
}

class _EmojiDropdownState extends State<EmojiDropdown> {
  final List<Map<String, String>> options = [
    {"emoji": "😊", "text": "Happy"},
    {"emoji": "😔", "text": "Sad"},
    {"emoji": "😌", "text": "Relaxed"},
    {"emoji": "😡", "text": "Angry"},
    {"emoji": "😴", "text": "Sleepy"},
    {"emoji": "😇", "text": "Blessed"},
  ];

  int selectedIndex = 0;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => isOpen = !isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  options[selectedIndex]["emoji"]!,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  options[selectedIndex]["text"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(options.length, (i) {
                if (i == selectedIndex) return const SizedBox.shrink();
                return ListTile(
                  leading: Text(
                    options[i]["emoji"]!,
                    style: const TextStyle(fontSize: 22),
                  ),
                  title: Text(
                    options[i]["text"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                      isOpen = false;
                    });
                  },
                );
              }),
            ),
          ),
      ],
    );
  }
} 