import 'package:flutter/material.dart';
import 'gratitude_entry_screen.dart';

class GratitudeCheckInFlow extends StatefulWidget {
  const GratitudeCheckInFlow({Key? key}) : super(key: key);

  @override
  State<GratitudeCheckInFlow> createState() => _GratitudeCheckInFlowState();
}

class _GratitudeCheckInFlowState extends State<GratitudeCheckInFlow> {
  @override
  Widget build(BuildContext context) {
    return _buildHistoryScreen();
  }

  Widget _buildHistoryScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF584378),
              Color(0xFF9E5E3B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Gratitude Check-Ins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GratitudeEntryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Week view
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Week header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.chevron_left, color: Colors.white),
                        const Text(
                          'Week of May 11',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Day circles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayCircle('S'),
                        _buildDayCircle('M'),
                        _buildDayCircle('T'),
                        _buildDayCircle('W'),
                        _buildDayCircle('T'),
                        _buildDayCircle('F'),
                        _buildDayCircle('S'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.white30, thickness: 1),
              ),
              
              const SizedBox(height: 40),
              
              // Empty state message
              const Text(
                'You haven\'t completed any',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'gratitude check-ins yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Start button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.white, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GratitudeEntryScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Start Gratitude Check-in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

  
  Widget _buildDayCircle(String day) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  

} 