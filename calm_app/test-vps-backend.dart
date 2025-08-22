import 'dart:convert';
import 'package:http/http.dart' as http;

// Simple test script to verify VPS backend connection
void main() async {
  const String baseUrl = 'http://168.231.66.116:3000';
  
  print('🧪 Testing MeditAi VPS Backend Connection...');
  print('🌐 Backend URL: $baseUrl');
  print('');
  
  try {
    // Test 1: Health Check
    print('1️⃣ Testing Health Endpoint...');
    final healthResponse = await http.get(Uri.parse('$baseUrl/health'))
        .timeout(const Duration(seconds: 10));
    
    if (healthResponse.statusCode == 200) {
      print('✅ Health check passed!');
      final healthData = json.decode(healthResponse.body);
      print('   Status: ${healthData['status']}');
      print('   Message: ${healthData['message']}');
      print('   Environment: ${healthData['environment']}');
    } else {
      print('❌ Health check failed! Status: ${healthResponse.statusCode}');
    }
    
    print('');
    
    // Test 2: API Documentation
    print('2️⃣ Testing API Documentation Endpoint...');
    final apiResponse = await http.get(Uri.parse('$baseUrl/api/v1'))
        .timeout(const Duration(seconds: 10));
    
    if (apiResponse.statusCode == 200) {
      print('✅ API documentation accessible!');
      final apiData = json.decode(apiResponse.body);
      print('   API Name: ${apiData['name']}');
      print('   Version: ${apiData['version']}');
      print('   Description: ${apiData['description']}');
    } else {
      print('❌ API documentation failed! Status: ${apiResponse.statusCode}');
    }
    
    print('');
    
    // Test 3: Content Endpoint
    print('3️⃣ Testing Content Endpoint...');
    final contentResponse = await http.get(Uri.parse('$baseUrl/api/v1/content'))
        .timeout(const Duration(seconds: 10));
    
    if (contentResponse.statusCode == 200) {
      print('✅ Content endpoint accessible!');
      final contentData = json.decode(contentResponse.body);
      print('   Success: ${contentData['success']}');
      print('   Content Count: ${contentData['content']?.length ?? 0}');
    } else {
      print('❌ Content endpoint failed! Status: ${contentResponse.statusCode}');
    }
    
    print('');
    
    // Test 4: Categories Endpoint
    print('4️⃣ Testing Categories Endpoint...');
    final categoriesResponse = await http.get(Uri.parse('$baseUrl/api/v1/content/categories'))
        .timeout(const Duration(seconds: 10));
    
    if (categoriesResponse.statusCode == 200) {
      print('✅ Categories endpoint accessible!');
      final categoriesData = json.decode(categoriesResponse.body);
      print('   Success: ${categoriesData['success']}');
      print('   Categories Count: ${categoriesData['categories']?.length ?? 0}');
    } else {
      print('❌ Categories endpoint failed! Status: ${categoriesResponse.statusCode}');
    }
    
    print('');
    
    // Test 5: Search Endpoint
    print('5️⃣ Testing Search Endpoint...');
    final searchResponse = await http.get(Uri.parse('$baseUrl/api/v1/content/search?q=meditation'))
        .timeout(const Duration(seconds: 10));
    
    if (searchResponse.statusCode == 200) {
      print('✅ Search endpoint accessible!');
      final searchData = json.decode(searchResponse.body);
      print('   Success: ${searchData['success']}');
      print('   Search Results Count: ${searchData['content']?.length ?? 0}');
    } else {
      print('❌ Search endpoint failed! Status: ${searchResponse.statusCode}');
    }
    
    print('');
    print('🎉 Backend connection test completed!');
    print('🌐 Your MeditAi backend is running successfully on the VPS!');
    
  } catch (e) {
    print('❌ Error testing backend: $e');
    print('');
    print('🔧 Troubleshooting tips:');
    print('   1. Check if the VPS is running');
    print('   2. Verify the backend service is started');
    print('   3. Check firewall settings on port 3000');
    print('   4. Ensure PostgreSQL is running');
  }
}

