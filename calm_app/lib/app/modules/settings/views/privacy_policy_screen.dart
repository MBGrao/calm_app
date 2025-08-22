import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../widgets/interactive_feedback.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isWebView = false;
  bool _isLoading = true;
  String _currentVersion = '1.2.0';
  String _lastUpdated = 'December 15, 2024';
  
  late WebViewController _webViewController;
  List<String> _filteredSections = [];
  
  final List<String> _allSections = [
    'Information We Collect',
    'How We Use Your Information',
    'Information Sharing',
    'Data Security',
    'Your Rights',
    'Cookies and Tracking',
    'Third-Party Services',
    'Children\'s Privacy',
    'International Transfers',
    'Changes to This Policy',
    'Contact Us',
  ];

  @override
  void initState() {
    super.initState();
    _filteredSections = List.from(_allSections);
    _searchController.addListener(_onSearchChanged);
    _initializeWebView();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadHtmlString(_getPrivacyPolicyHTML());
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSections = _allSections.where((section) {
        return section.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  String _getPrivacyPolicyHTML() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                line-height: 1.6;
                color: #333;
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #1B4B6F;
                border-bottom: 2px solid #1B4B6F;
                padding-bottom: 10px;
            }
            h2 {
                color: #2C6CA9;
                margin-top: 30px;
            }
            h3 {
                color: #1B4B6F;
                margin-top: 20px;
            }
            .version-info {
                background: #e3f2fd;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #1B4B6F;
            }
            .highlight {
                background: #fff3cd;
                padding: 10px;
                border-radius: 5px;
                border-left: 4px solid #ffc107;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="version-info">
                <strong>Version:</strong> $_currentVersion<br>
                <strong>Last Updated:</strong> $_lastUpdated
            </div>
            
            <h1>Privacy Policy</h1>
            
            <p>Welcome to MeditAi. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use our meditation and wellness application.</p>
            
            <h2>Information We Collect</h2>
            
            <h3>Personal Information</h3>
            <ul>
                <li>Name and email address when you create an account</li>
                <li>Profile information including meditation preferences</li>
                <li>Usage data and meditation session history</li>
                <li>Device information and app performance data</li>
            </ul>
            
            <h3>Health and Wellness Data</h3>
            <ul>
                <li>Meditation session duration and frequency</li>
                <li>Mood check-ins and wellness assessments</li>
                <li>Sleep tracking data (if enabled)</li>
                <li>Breathing exercise patterns</li>
            </ul>
            
            <h2>How We Use Your Information</h2>
            
            <p>We use your information to:</p>
            <ul>
                <li>Provide personalized meditation recommendations</li>
                <li>Track your progress and celebrate achievements</li>
                <li>Improve our app features and user experience</li>
                <li>Send relevant notifications and updates</li>
                <li>Provide customer support and respond to inquiries</li>
            </ul>
            
            <h2>Information Sharing</h2>
            
            <p>We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:</p>
            <ul>
                <li>With your explicit consent</li>
                <li>To comply with legal obligations</li>
                <li>To protect our rights and safety</li>
                <li>With trusted service providers who assist in app operations</li>
            </ul>
            
            <h2>Data Security</h2>
            
            <p>We implement industry-standard security measures to protect your data:</p>
            <ul>
                <li>End-to-end encryption for sensitive data</li>
                <li>Secure cloud storage with regular backups</li>
                <li>Access controls and authentication</li>
                <li>Regular security audits and updates</li>
            </ul>
            
            <h2>Your Rights</h2>
            
            <p>You have the right to:</p>
            <ul>
                <li>Access your personal data</li>
                <li>Correct inaccurate information</li>
                <li>Request deletion of your data</li>
                <li>Export your data in a portable format</li>
                <li>Opt-out of marketing communications</li>
                <li>Withdraw consent at any time</li>
            </ul>
            
            <h2>Cookies and Tracking</h2>
            
            <p>We use cookies and similar technologies to:</p>
            <ul>
                <li>Remember your preferences and settings</li>
                <li>Analyze app usage and performance</li>
                <li>Provide personalized content</li>
                <li>Improve user experience</li>
            </ul>
            
            <h2>Third-Party Services</h2>
            
            <p>Our app may integrate with third-party services for:</p>
            <ul>
                <li>Analytics and performance monitoring</li>
                <li>Payment processing</li>
                <li>Cloud storage and backup</li>
                <li>Customer support tools</li>
            </ul>
            
            <h2>Children's Privacy</h2>
            
            <p>Our app is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you believe we have collected such information, please contact us immediately.</p>
            
            <h2>International Transfers</h2>
            
            <p>Your data may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data during international transfers.</p>
            
            <h2>Changes to This Policy</h2>
            
            <p>We may update this privacy policy from time to time. We will notify you of any material changes through the app or email. Your continued use of the app after changes constitutes acceptance of the updated policy.</p>
            
            <h2>Contact Us</h2>
            
            <p>If you have questions about this privacy policy or our data practices, please contact us:</p>
            <ul>
                <li>Email: privacy@meditai.com</li>
                <li>Address: 123 Wellness Street, Mindful City, MC 12345</li>
                <li>Phone: +1 (555) 123-4567</li>
            </ul>
            
            <div class="highlight">
                <strong>Effective Date:</strong> This privacy policy is effective as of $_lastUpdated.
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  void _toggleWebView() {
    setState(() {
      _isWebView = !_isWebView;
    });
    HapticFeedbackHelper.lightImpact();
  }

  void _acceptPolicy() {
    HapticFeedbackHelper.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy Policy accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _declinePolicy() {
    HapticFeedbackHelper.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2631),
        title: const Text(
          'Decline Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You must accept the Privacy Policy to use MeditAi. Would you like to review it again or contact support?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedbackHelper.lightImpact();
            },
            child: const Text(
              'Review Again',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              HapticFeedbackHelper.lightImpact();
            },
            child: const Text(
              'Contact Support',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B4B6F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isWebView ? Icons.list : Icons.web,
              color: Colors.white,
            ),
            onPressed: _toggleWebView,
          ),
        ],
      ),
      body: Column(
        children: [
          // Version and Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Version Info
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Version $_currentVersion',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Last updated: $_lastUpdated',
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
                ),
                SizedBox(height: 12.h),
                
                // Search Bar
                if (!_isWebView) ...[
                  Container(
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
                              hintText: 'Search privacy policy...',
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
                  ),
                ],
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _isWebView
                ? Stack(
                    children: [
                      WebViewWidget(controller: _webViewController),
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                    ],
                  )
                : _buildStaticContent(),
          ),
          
          // Action Buttons
          if (!_isWebView) ...[
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _declinePolicy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _acceptPolicy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStaticContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          Text(
            'Welcome to MeditAi. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use our meditation and wellness application.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 24.h),
          
          ..._filteredSections.map((section) => _buildSectionCard(section)).toList(),
          
          SizedBox(height: 24.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'If you have questions about this privacy policy or our data practices, please contact us:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Email: privacy@meditai.com\nPhone: +1 (555) 123-4567',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String section) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _getSectionPreview(section),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () {
              _toggleWebView();
              HapticFeedbackHelper.lightImpact();
            },
            child: Text(
              'Read Full Section',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSectionPreview(String section) {
    switch (section) {
      case 'Information We Collect':
        return 'We collect personal information, health data, and usage statistics to provide personalized meditation experiences.';
      case 'How We Use Your Information':
        return 'Your information helps us provide personalized recommendations, track progress, and improve our services.';
      case 'Information Sharing':
        return 'We do not sell your data. We only share information with your consent or as required by law.';
      case 'Data Security':
        return 'We implement industry-standard security measures including encryption and secure cloud storage.';
      case 'Your Rights':
        return 'You have the right to access, correct, delete, and export your personal data at any time.';
      case 'Cookies and Tracking':
        return 'We use cookies to remember preferences, analyze usage, and provide personalized content.';
      case 'Third-Party Services':
        return 'We may integrate with trusted third-party services for analytics, payments, and support.';
      case 'Children\'s Privacy':
        return 'Our app is not intended for children under 13. We do not knowingly collect their data.';
      case 'International Transfers':
        return 'Your data may be transferred internationally with appropriate safeguards in place.';
      case 'Changes to This Policy':
        return 'We may update this policy and will notify you of material changes through the app or email.';
      case 'Contact Us':
        return 'Contact us with questions about this privacy policy or our data practices.';
      default:
        return 'Click to read the full section details.';
    }
  }
} 