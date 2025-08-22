import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as developer;

class SimpleAIAssistantScreen extends StatefulWidget {
  const SimpleAIAssistantScreen({Key? key}) : super(key: key);

  @override
  State<SimpleAIAssistantScreen> createState() => _SimpleAIAssistantScreenState();
}

class _SimpleAIAssistantScreenState extends State<SimpleAIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _conversation = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    developer.log('🎯 Simple AI Assistant Screen - initState called', name: 'SimpleAIAssistantScreen');
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _conversation.add({
      'text': 'Hello! I\'m your AI meditation assistant. How can I help you today?',
      'isAI': true,
      'timestamp': DateTime.now(),
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text.trim();
    _conversation.add({
      'text': userMessage,
      'isAI': false,
      'timestamp': DateTime.now(),
    });

    setState(() {
      _isProcessing = true;
    });

    _textController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _conversation.add({
            'text': _generateAIResponse(userMessage),
            'isAI': true,
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('meditation') || lowerMessage.contains('meditate')) {
      return 'I\'d be happy to guide you through a meditation session! Would you like a 5-minute breathing meditation or a 10-minute mindfulness practice?';
    } else if (lowerMessage.contains('stress') || lowerMessage.contains('anxiety')) {
      return 'I understand stress can be overwhelming. Let me help you with some stress relief techniques. Try taking 3 deep breaths right now.';
    } else if (lowerMessage.contains('sleep') || lowerMessage.contains('tired')) {
      return 'Sleep is crucial for well-being. I can help you with sleep meditation or breathing techniques. Would you like to try a sleep-inducing meditation?';
    } else if (lowerMessage.contains('breathing') || lowerMessage.contains('breathe')) {
      return 'Breathing exercises are excellent for relaxation. Let\'s do a simple 4-7-8 breathing technique together.';
    } else {
      return 'I\'m here to help you with meditation, breathing exercises, stress relief, and mindfulness practices. What would you like to work on today?';
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log('🎯 Simple AI Assistant Screen - build called', name: 'SimpleAIAssistantScreen');
    
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            developer.log('🎯 Simple AI Assistant Screen - Back button pressed', name: 'SimpleAIAssistantScreen');
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'AI Assistant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _conversation.clear();
                _addWelcomeMessage();
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Conversation area
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _conversation.length + (_isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _conversation.length && _isProcessing) {
                  return _buildTypingIndicator();
                }
                
                final message = _conversation[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isAI = message['isAI'] as bool;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAI) ...[
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16.r,
              child: Icon(Icons.psychology, color: Colors.white, size: 16.sp),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isAI 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isAI 
                      ? Colors.white.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                message['text'] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          if (!isAI) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16.r,
              child: Icon(Icons.person, color: Colors.white, size: 16.sp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 16.r,
            child: Icon(Icons.psychology, color: Colors.white, size: 16.sp),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'AI is typing...',
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
    );
  }
} 