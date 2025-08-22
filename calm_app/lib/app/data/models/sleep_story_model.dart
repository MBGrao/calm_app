class SleepStory {
  final String title;
  final String imageUrl;
  final String duration;
  final String description;
  final String category;

  SleepStory({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.description,
    required this.category,
  });
}

// Dummy data for sleep stories
final List<SleepStory> dummySleepStories = [
  SleepStory(
    title: 'Starlit Night Journey',
    imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=800&q=80',
    duration: '45 min',
    description: 'A peaceful journey through a starlit night sky, guided by the gentle voice of AI.',
    category: 'Space',
  ),
  SleepStory(
    title: 'Ocean Waves',
    imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
    duration: '30 min',
    description: 'Drift into sleep with the calming sounds of ocean waves and gentle narration.',
    category: 'Nature',
  ),
  SleepStory(
    title: 'Mountain Retreat',
    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80',
    duration: '40 min',
    description: 'A serene journey through misty mountains and peaceful valleys.',
    category: 'Nature',
  ),
  SleepStory(
    title: 'Cosmic Dreams',
    imageUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=800&q=80',
    duration: '35 min',
    description: 'Explore the wonders of the universe as you drift into a peaceful sleep.',
    category: 'Space',
  ),
  SleepStory(
    title: 'Forest Whispers',
    imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80',
    duration: '25 min',
    description: 'Let the gentle whispers of the forest guide you into a deep, restful sleep.',
    category: 'Nature',
  ),
]; 