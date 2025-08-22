import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/interactive_feedback.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _filteredFAQs = [];
  bool _isSearching = false;
  bool _isSubmittingContact = false;
  
  final List<String> _categories = ['All', 'Getting Started', 'Meditation', 'Account', 'Technical', 'Billing'];
  
  final List<Map<String, dynamic>> _allFAQs = [
    {
      'question': 'How do I start my first meditation?',
      'answer': 'Tap the "Start" button on any meditation card. We recommend starting with "Beginner\'s Mind" for your first session. Find a quiet place, sit comfortably, and follow the guided instructions.',
      'category': 'Getting Started',
      'tags': ['beginner', 'first-time', 'meditation']
    },
    {
      'question': 'How long should I meditate?',
      'answer': 'Start with 5-10 minutes daily. You can gradually increase to 15-20 minutes as you become more comfortable. Consistency is more important than duration.',
      'category': 'Meditation',
      'tags': ['duration', 'time', 'practice']
    },
    {
      'question': 'Can I use the app offline?',
      'answer': 'Yes! Download your favorite meditations while connected to WiFi, and they\'ll be available offline. Go to any meditation and tap the download icon.',
      'category': 'Technical',
      'tags': ['offline', 'download', 'wifi']
    },
    {
      'question': 'How do I change my meditation preferences?',
      'answer': 'Go to Settings > Profile Settings > Meditation Preferences. You can set your preferred duration, type, and reminder times there.',
      'category': 'Account',
      'tags': ['settings', 'preferences', 'customization']
    },
    {
      'question': 'What\'s the difference between meditation types?',
      'answer': 'Mindfulness focuses on present awareness, Loving-Kindness cultivates compassion, Body Scan promotes body awareness, and Breathing helps with relaxation and focus.',
      'category': 'Meditation',
      'tags': ['types', 'mindfulness', 'loving-kindness', 'body-scan']
    },
    {
      'question': 'How do I track my progress?',
      'answer': 'Your progress is automatically tracked in the Profile section. You can view your meditation streak, total sessions, and weekly summaries.',
      'category': 'Account',
      'tags': ['progress', 'tracking', 'stats']
    },
    {
      'question': 'Can I cancel my subscription?',
      'answer': 'Yes, you can cancel anytime. Go to Settings > Account > Subscription to manage your subscription or contact support for assistance.',
      'category': 'Billing',
      'tags': ['subscription', 'cancel', 'billing']
    },
    {
      'question': 'Why aren\'t my notifications working?',
      'answer': 'Check your device settings and ensure notifications are enabled for MeditAi. Also verify your notification preferences in Settings > Notifications.',
      'category': 'Technical',
      'tags': ['notifications', 'settings', 'device']
    },
    {
      'question': 'How do I reset my password?',
      'answer': 'On the login screen, tap "Forgot Password" and enter your email address. You\'ll receive a link to reset your password.',
      'category': 'Account',
      'tags': ['password', 'reset', 'login']
    },
    {
      'question': 'What devices are supported?',
      'answer': 'MeditAi works on iOS 12+ and Android 6+ devices. We also support web browsers for desktop access.',
      'category': 'Technical',
      'tags': ['devices', 'compatibility', 'platforms']
    },
  ];

  final List<Map<String, dynamic>> _gettingStartedSteps = [
    {
      'title': 'Create Your Account',
      'description': 'Sign up with your email or social media account to get started.',
      'icon': Icons.person_add,
      'duration': '2 minutes'
    },
    {
      'title': 'Complete Your Profile',
      'description': 'Set your meditation preferences and personal goals.',
      'icon': Icons.settings,
      'duration': '3 minutes'
    },
    {
      'title': 'Choose Your First Meditation',
      'description': 'Start with our beginner-friendly guided sessions.',
      'icon': Icons.play_circle,
      'duration': '5 minutes'
    },
    {
      'title': 'Set Up Reminders',
      'description': 'Schedule daily meditation reminders to build a habit.',
      'icon': Icons.notifications,
      'duration': '2 minutes'
    },
    {
      'title': 'Track Your Progress',
      'description': 'Monitor your meditation journey and celebrate milestones.',
      'icon': Icons.trending_up,
      'duration': '1 minute'
    },
  ];

  final List<Map<String, dynamic>> _meditationTutorials = [
    {
      'title': 'Breathing Basics',
      'description': 'Learn the foundation of mindful breathing',
      'duration': '8 min',
      'thumbnail': 'assets/icons/home_screen/breathing.png',
      'videoUrl': 'https://example.com/breathing-basics'
    },
    {
      'title': 'Body Scan Technique',
      'description': 'Discover how to scan your body for tension',
      'duration': '12 min',
      'thumbnail': 'assets/icons/home_screen/body-scan.png',
      'videoUrl': 'https://example.com/body-scan'
    },
    {
      'title': 'Loving-Kindness Practice',
      'description': 'Cultivate compassion for yourself and others',
      'duration': '15 min',
      'thumbnail': 'assets/icons/home_screen/loving-kindness.png',
      'videoUrl': 'https://example.com/loving-kindness'
    },
    {
      'title': 'Walking Meditation',
      'description': 'Practice mindfulness while walking',
      'duration': '10 min',
      'thumbnail': 'assets/icons/home_screen/walking.png',
      'videoUrl': 'https://example.com/walking-meditation'
    },
  ];

  final List<Map<String, dynamic>> _troubleshootingIssues = [
    {
      'issue': 'App won\'t open',
      'solution': 'Try restarting your device and reinstalling the app. Check if you have sufficient storage space.',
      'category': 'Technical'
    },
    {
      'issue': 'Audio not playing',
      'solution': 'Check your device volume and ensure the app has audio permissions. Try closing other audio apps.',
      'category': 'Technical'
    },
    {
      'issue': 'Can\'t log in',
      'solution': 'Verify your email and password. Use the "Forgot Password" feature if needed.',
      'category': 'Account'
    },
    {
      'issue': 'Meditations not downloading',
      'solution': 'Check your internet connection and available storage space. Try downloading one meditation at a time.',
      'category': 'Technical'
    },
    {
      'issue': 'Notifications not working',
      'solution': 'Go to device settings > Apps > MeditAi > Notifications and ensure they\'re enabled.',
      'category': 'Technical'
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredFAQs = List.from(_allFAQs);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterFAQs();
  }

  void _filterFAQs() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredFAQs = _allFAQs.where((faq) {
            final searchQuery = _searchController.text.toLowerCase();
            final question = faq['question'].toLowerCase();
            final answer = faq['answer'].toLowerCase();
            final category = faq['category'].toLowerCase();
            final tags = (faq['tags'] as List).join(' ').toLowerCase();
            
            final matchesSearch = searchQuery.isEmpty || 
                question.contains(searchQuery) || 
                answer.contains(searchQuery) || 
                category.contains(searchQuery) ||
                tags.contains(searchQuery);
            
            final matchesCategory = _selectedCategory == 'All' || 
                faq['category'] == _selectedCategory;
            
            return matchesSearch && matchesCategory;
          }).toList();
          _isSearching = false;
        });
      }
    });
  }

  void _showFAQDialog(Map<String, dynamic> faq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2631),
        title: Text(
          faq['question'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            faq['answer'],
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedbackHelper.lightImpact();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitContactForm() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingContact = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isSubmittingContact = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully! We\'ll get back to you soon.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        
        HapticFeedbackHelper.mediumImpact();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmittingContact = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B4B6F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            SizedBox(height: 24.h),
            
            // Quick Actions
            _buildQuickActions(),
            SizedBox(height: 24.h),
            
            // Getting Started
            _buildGettingStartedSection(),
            SizedBox(height: 24.h),
            
            // FAQ Section
            _buildFAQSection(),
            SizedBox(height: 24.h),
            
            // Meditation Tutorials
            _buildTutorialsSection(),
            SizedBox(height: 24.h),
            
            // Troubleshooting
            _buildTroubleshootingSection(),
            SizedBox(height: 24.h),
            
            // Contact Support
            _buildContactSection(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white70, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search help articles...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white70, size: 20.sp),
              onPressed: () {
                _searchController.clear();
                HapticFeedbackHelper.lightImpact();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.play_circle_outline,
                title: 'Start Meditating',
                onTap: () {
                  HapticFeedbackHelper.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  HapticFeedbackHelper.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGettingStartedSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Getting Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ..._gettingStartedSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          step['description'],
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          step['duration'],
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.question_answer, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterFAQs();
                      HapticFeedbackHelper.lightImpact();
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: Colors.orange.withOpacity(0.3),
                    side: BorderSide(
                      color: isSelected ? Colors.orange : Colors.white30,
                    ),
                    checkmarkColor: Colors.orange,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          
          // FAQ List
          if (_isSearching)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (_filteredFAQs.isEmpty)
            Center(
              child: Text(
                'No questions found',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
              ),
            )
          else
            ..._filteredFAQs.map((faq) => _buildFAQItem(faq)).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ListTile(
        title: Text(
          faq['question'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          faq['category'],
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12.sp,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 16,
        ),
        onTap: () {
          _showFAQDialog(faq);
          HapticFeedbackHelper.lightImpact();
        },
      ),
    );
  }

  Widget _buildTutorialsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.video_library, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Meditation Tutorials',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          ..._meditationTutorials.map((tutorial) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutorial['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tutorial['description'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tutorial['duration'],
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.orange),
                  onPressed: () {
                    HapticFeedbackHelper.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Playing: ${tutorial['title']}'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Troubleshooting',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          ..._troubleshootingIssues.map((issue) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ExpansionTile(
              title: Text(
                issue['issue'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                issue['category'],
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12.sp,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    issue['solution'],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Contact Support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Your Name',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          
          TextFormField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Message',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: _isSubmittingContact ? null : _submitContactForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _isSubmittingContact
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
} 