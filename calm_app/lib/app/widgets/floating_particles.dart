import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticles extends StatefulWidget {
  @override
  _FloatingParticlesState createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles> with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    particles = List.generate(20, (index) => Particle());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(particles),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = math.Random().nextDouble() * 400;
  double y = math.Random().nextDouble() * 800;
  double speed = math.Random().nextDouble() * 2 + 1;
  double size = math.Random().nextDouble() * 3 + 1;
  double opacity = math.Random().nextDouble() * 0.5 + 0.1;
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;

  ParticlesPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );

      particle.y -= particle.speed;
      if (particle.y < 0) {
        particle.y = size.height;
        particle.x = math.Random().nextDouble() * size.width;
      }
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
} 