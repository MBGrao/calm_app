import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../widgets/interactive_feedback.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isWebView = false;
  bool _isLoading = true;
  String _currentVersion = '2.1.0';
  String _lastUpdated = 'December 15, 2024';
  
  late WebViewController _webViewController;
  List<String> _filteredSections = [];
  
  final List<String> _allSections = [
    'Acceptance of Terms',
    'Description of Service',
    'User Accounts',
    'Acceptable Use',
    'Intellectual Property',
    'Privacy and Data',
    'Subscription and Payments',
    'Termination',
    'Disclaimers',
    'Limitation of Liability',
    'Governing Law',
    'Changes to Terms',
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
      ..loadHtmlString(_getTermsOfServiceHTML());
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSections = _allSections.where((section) {
        return section.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  String _getTermsOfServiceHTML() {
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
            .important {
                background: #f8d7da;
                padding: 10px;
                border-radius: 5px;
                border-left: 4px solid #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="version-info">
                <strong>Version:</strong> $_currentVersion<br>
                <strong>Last Updated:</strong> $_lastUpdated
            </div>
            
            <h1>Terms of Service</h1>
            
            <p>Welcome to MeditAi. These Terms of Service ("Terms") govern your use of our meditation and wellness application. By accessing or using MeditAi, you agree to be bound by these Terms.</p>
            
            <h2>Acceptance of Terms</h2>
            
            <p>By downloading, installing, or using MeditAi, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree to these Terms, you must not use our application.</p>
            
            <div class="important">
                <strong>Important:</strong> These Terms constitute a legally binding agreement between you and MeditAi. Please read them carefully.
            </div>
            
            <h2>Description of Service</h2>
            
            <p>MeditAi is a mobile application that provides:</p>
            <ul>
                <li>Guided meditation sessions and mindfulness exercises</li>
                <li>Sleep stories and relaxation content</li>
                <li>Breathing exercises and stress relief techniques</li>
                <li>Progress tracking and wellness assessments</li>
                <li>Personalized recommendations and content curation</li>
                <li>Community features and social sharing</li>
            </ul>
            
            <h2>User Accounts</h2>
            
            <h3>Account Creation</h3>
            <p>To access certain features, you must create an account. You agree to:</p>
            <ul>
                <li>Provide accurate and complete information</li>
                <li>Maintain the security of your account credentials</li>
                <li>Notify us immediately of any unauthorized access</li>
                <li>Accept responsibility for all activities under your account</li>
            </ul>
            
            <h3>Account Responsibilities</h3>
            <p>You are responsible for:</p>
            <ul>
                <li>All activities that occur under your account</li>
                <li>Maintaining the confidentiality of your password</li>
                <li>Ensuring your account information is up to date</li>
                <li>Notifying us of any security concerns</li>
            </ul>
            
            <h2>Acceptable Use</h2>
            
            <p>You agree to use MeditAi only for lawful purposes and in accordance with these Terms. You agree not to:</p>
            <ul>
                <li>Use the service for any illegal or unauthorized purpose</li>
                <li>Attempt to gain unauthorized access to our systems</li>
                <li>Interfere with or disrupt the service or servers</li>
                <li>Share your account credentials with others</li>
                <li>Use automated tools to access the service</li>
                <li>Violate any applicable laws or regulations</li>
                <li>Harass, abuse, or harm other users</li>
            </ul>
            
            <h2>Intellectual Property</h2>
            
            <h3>Our Rights</h3>
            <p>MeditAi and its content, including but not limited to:</p>
            <ul>
                <li>Text, graphics, images, audio, and video content</li>
                <li>Software, code, and technical specifications</li>
                <li>Trademarks, service marks, and logos</li>
                <li>User interface design and layout</li>
            </ul>
            <p>are owned by MeditAi or its licensors and are protected by intellectual property laws.</p>
            
            <h3>Your Rights</h3>
            <p>You retain ownership of content you create and share through the service, but you grant us a license to use, display, and distribute such content in connection with the service.</p>
            
            <h2>Privacy and Data</h2>
            
            <p>Your privacy is important to us. Our collection and use of your personal information is governed by our Privacy Policy, which is incorporated into these Terms by reference.</p>
            
            <p>By using MeditAi, you consent to:</p>
            <ul>
                <li>The collection and use of your data as described in our Privacy Policy</li>
                <li>The processing of your data in accordance with applicable laws</li>
                <li>The transfer of your data to servers in different countries</li>
            </ul>
            
            <h2>Subscription and Payments</h2>
            
            <h3>Free and Premium Services</h3>
            <p>MeditAi offers both free and premium subscription services. Premium features require a paid subscription.</p>
            
            <h3>Payment Terms</h3>
            <ul>
                <li>Subscription fees are billed in advance on a recurring basis</li>
                <li>All fees are non-refundable except as required by law</li>
                <li>We may change subscription prices with 30 days notice</li>
                <li>You may cancel your subscription at any time</li>
            </ul>
            
            <h3>Automatic Renewal</h3>
            <p>Subscriptions automatically renew unless cancelled before the renewal date. You can manage your subscription through your device's app store settings.</p>
            
            <h2>Termination</h2>
            
            <h3>Your Right to Terminate</h3>
            <p>You may terminate your account at any time by:</p>
            <ul>
                <li>Deleting the app from your device</li>
                <li>Contacting our support team</li>
                <li>Using the account deletion feature in the app</li>
            </ul>
            
            <h3>Our Right to Terminate</h3>
            <p>We may terminate or suspend your account if:</p>
            <ul>
                <li>You violate these Terms</li>
                <li>You engage in fraudulent or illegal activities</li>
                <li>We are required to do so by law</li>
                <li>We discontinue the service</li>
            </ul>
            
            <h3>Effect of Termination</h3>
            <p>Upon termination:</p>
            <ul>
                <li>Your access to the service will cease immediately</li>
                <li>We may delete your account and data</li>
                <li>Any unused subscription time will be forfeited</li>
                <li>Provisions that survive termination will remain in effect</li>
            </ul>
            
            <h2>Disclaimers</h2>
            
            <div class="important">
                <p><strong>Medical Disclaimer:</strong> MeditAi is not a substitute for professional medical advice, diagnosis, or treatment. Always consult with qualified healthcare providers for medical concerns.</p>
            </div>
            
            <p>THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO:</p>
            <ul>
                <li>Warranties of merchantability and fitness for a particular purpose</li>
                <li>Warranties that the service will be uninterrupted or error-free</li>
                <li>Warranties regarding the accuracy or reliability of content</li>
                <li>Warranties that defects will be corrected</li>
            </ul>
            
            <h2>Limitation of Liability</h2>
            
            <p>TO THE MAXIMUM EXTENT PERMITTED BY LAW, MEDITAI SHALL NOT BE LIABLE FOR:</p>
            <ul>
                <li>Indirect, incidental, special, consequential, or punitive damages</li>
                <li>Loss of profits, data, or business opportunities</li>
                <li>Personal injury or property damage</li>
                <li>Any damages arising from your use of the service</li>
            </ul>
            
            <p>Our total liability shall not exceed the amount you paid for the service in the 12 months preceding the claim.</p>
            
            <h2>Governing Law</h2>
            
            <p>These Terms are governed by and construed in accordance with the laws of [Jurisdiction], without regard to conflict of law principles.</p>
            
            <p>Any disputes arising from these Terms or your use of the service shall be resolved through binding arbitration in accordance with the rules of [Arbitration Organization].</p>
            
            <h2>Changes to Terms</h2>
            
            <p>We may update these Terms from time to time. We will notify you of material changes by:</p>
            <ul>
                <li>Posting the updated Terms in the app</li>
                <li>Sending you an email notification</li>
                <li>Displaying a notice when you next open the app</li>
            </ul>
            
            <p>Your continued use of the service after changes become effective constitutes acceptance of the updated Terms.</p>
            
            <h2>Contact Information</h2>
            
            <p>If you have questions about these Terms, please contact us:</p>
            <ul>
                <li>Email: legal@meditai.com</li>
                <li>Address: 123 Wellness Street, Mindful City, MC 12345</li>
                <li>Phone: +1 (555) 123-4567</li>
            </ul>
            
            <div class="highlight">
                <strong>Effective Date:</strong> These Terms are effective as of $_lastUpdated.
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

  void _acceptTerms() {
    HapticFeedbackHelper.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of Service accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _declineTerms() {
    HapticFeedbackHelper.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2631),
        title: const Text(
          'Decline Terms of Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You must accept the Terms of Service to use MeditAi. Would you like to review them again or contact support?',
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
          'Terms of Service',
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
                              hintText: 'Search terms of service...',
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
                      onPressed: _declineTerms,
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
                      onPressed: _acceptTerms,
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
            'Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          Text(
            'Welcome to MeditAi. These Terms of Service govern your use of our meditation and wellness application. By accessing or using MeditAi, you agree to be bound by these Terms.',
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
                  'Contact Information',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'If you have questions about these Terms, please contact us:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Email: legal@meditai.com\nPhone: +1 (555) 123-4567',
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
      case 'Acceptance of Terms':
        return 'By using MeditAi, you acknowledge that you have read, understood, and agree to be bound by these Terms.';
      case 'Description of Service':
        return 'MeditAi provides guided meditation sessions, sleep stories, breathing exercises, and wellness tracking features.';
      case 'User Accounts':
        return 'You must create an account to access certain features and are responsible for maintaining account security.';
      case 'Acceptable Use':
        return 'You agree to use the service only for lawful purposes and not to interfere with or disrupt the service.';
      case 'Intellectual Property':
        return 'MeditAi content is protected by intellectual property laws. You retain rights to your user-generated content.';
      case 'Privacy and Data':
        return 'Your privacy is governed by our Privacy Policy. You consent to data collection and processing as described.';
      case 'Subscription and Payments':
        return 'Premium features require a paid subscription. Fees are non-refundable and subscriptions auto-renew.';
      case 'Termination':
        return 'You may terminate your account at any time. We may terminate accounts for Terms violations.';
      case 'Disclaimers':
        return 'The service is provided "as is" and is not a substitute for professional medical advice or treatment.';
      case 'Limitation of Liability':
        return 'Our liability is limited to the amount you paid for the service in the 12 months preceding any claim.';
      case 'Governing Law':
        return 'These Terms are governed by applicable laws and disputes are resolved through binding arbitration.';
      case 'Changes to Terms':
        return 'We may update these Terms and will notify you of material changes through the app or email.';
      default:
        return 'Click to read the full section details.';
    }
  }
} 