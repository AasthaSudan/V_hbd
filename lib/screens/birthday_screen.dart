import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:async';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _chandelierController;
  late AnimationController _confettiController;
  late AnimationController _textController;
  late AnimationController _photoController;

  List<int> activeBulbs = [];
  List<ConfettiParticle> confettiParticles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startChandelierAnimation();
    _generateConfetti();
  }

  void _initializeAnimations() {
    _chandelierController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _photoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _generateConfetti() {
    confettiParticles.clear();
    for (int i = 0; i < 50; i++) {
      confettiParticles.add(ConfettiParticle(
        x: math.Random().nextDouble(),
        delay: math.Random().nextDouble() * 3,
        duration: 3 + math.Random().nextDouble() * 2,
        color: [Colors.amber, Colors.grey.shade300, Colors.pink, Colors.cyan][
        math.Random().nextInt(4)],
      ));
    }
  }

  void _startChandelierAnimation() {
    int currentBulb = 0;
    const int totalBulbs = 16;

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          if (!activeBulbs.contains(currentBulb)) {
            activeBulbs.add(currentBulb);
          }
        });

        currentBulb = (currentBulb + 1) % totalBulbs;

        if (activeBulbs.length == totalBulbs) {
          _textController.forward();
          _photoController.forward();
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _chandelierController.dispose();
    _confettiController.dispose();
    _textController.dispose();
    _photoController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[900], // Simple black background
      body: Stack(
        children: [
          // Confetti Animation
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return Stack(
                children: confettiParticles.map((particle) {
                  double progress = (_confettiController.value + particle.delay) % 1.0;
                  return Positioned(
                    left: screenWidth * particle.x,
                    top: -20 + (screenHeight + 40) * progress,
                    child: Transform.rotate(
                      angle: progress * 6.28,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: particle.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Fixed Chandelier
                _buildChandelier(screenWidth),

                SizedBox(height: 20),

                // Photo Section
                AnimatedBuilder(
                  animation: _photoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.5 + (_photoController.value * 0.5),
                      child: Opacity(
                        opacity: _photoController.value,
                        child: _buildPhotoSection(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Birthday Text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _textController.value)),
                      child: Opacity(
                        opacity: _textController.value,
                        child: _buildBirthdayText(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Photo Gallery
                _buildPhotoGallery(),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundStar(int index, double screenWidth, double screenHeight) {
    final random = math.Random(index);
    return Positioned(
      left: random.nextDouble() * screenWidth,
      top: 150 + (random.nextDouble() * (screenHeight - 200)),
      child: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          return Opacity(
            opacity: 0.3 + 0.4 * math.sin(_confettiController.value * 6.28 + index),
            child: Icon(
              Icons.star,
              color: index % 2 == 0 ? Colors.amber.shade200 : Colors.grey.shade300,
              size: 8 + random.nextDouble() * 6,
            ),
          );
        },
      ),
    );
  }

  Widget _buildChandelier(double screenWidth) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2196F3),
            const Color(0xFF64B5F6).withOpacity(0.8),
            const Color(0xFF64B5F6).withOpacity(0.0),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Chain
          Positioned(
            left: screenWidth / 2 - 1,
            top: 0,
            child: Container(
              width: 2,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                ),
              ),
            ),
          ),

          // Base (larger chandelier base)
          Positioned(
            left: screenWidth / 2 - 60,
            top: 45,
            child: Container(
              width: 120,
              height: 25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade600, Colors.amber.shade800],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade300.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),

          // Bulbs - Full circle
          ...List.generate(16, (index) => _buildChandelierBulb(index, screenWidth)),
        ],
      ),
    );
  }

  Widget _buildChandelierBulb(int index, double screenWidth) {
    final double angle = (index * 22.5) * math.pi / 180; // 360/16 = 22.5 degrees
    final double radius = math.min(screenWidth * 0.25, 120);
    final bool isActive = activeBulbs.contains(index);
    final bool isGold = index % 2 == 0;

    return Positioned(
      left: screenWidth / 2 + math.cos(angle) * radius - 10,
      top: 75 + math.sin(angle) * 30,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 20,
        height: 28,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isGold
                ? [Colors.yellow.shade200, Colors.amber.shade500]
                : [Colors.grey.shade200, Colors.grey.shade400],
          )
              : const LinearGradient(
            colors: [Color(0xFF444444), Color(0xFF222222)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: isGold ? Colors.amber.shade300 : Colors.grey.shade300,
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: isActive
            ? AnimatedBuilder(
          animation: _chandelierController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: (isGold ? Colors.amber : Colors.grey)
                        .withOpacity(0.4 + 0.3 * math.sin(_chandelierController.value * 6.28)),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
            );
          },
        )
            : null,
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Photo
        Container(
          width: 220,
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade400, Colors.amber.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.shade300.withOpacity(0.6),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/imgs.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Cake Overlay
        Positioned(
          bottom: -25,
          right: -25,
          child: AnimatedBuilder(
            animation: _photoController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 5 * math.sin(_photoController.value * 6.28)),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade300, Colors.pink.shade500],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade200.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎂', style: TextStyle(fontSize: 40)),
                  ),
                ),
              );
            },
          ),
        ),

        // Sparkles
        Positioned(
          top: -20,
          left: -20,
          child: _buildSparkle('✨', Colors.amber),
        ),
        Positioned(
          top: -15,
          right: -30,
          child: _buildSparkle('⭐', Colors.grey.shade300),
        ),
        Positioned(
          bottom: -15,
          left: -30,
          child: _buildSparkle('✨', Colors.amber.shade300),
        ),
      ],
    );
  }

  Widget _buildSparkle(String emoji, Color color) {
    return AnimatedBuilder(
      animation: _photoController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.3 * math.sin(_photoController.value * 6.28),
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 28,
              color: color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBirthdayText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white],
          ).createShader(bounds),
          child: Text(
            'Happy Birthday',
            style: GoogleFonts.dancingScript(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white],
          ).createShader(bounds),
          child: Text(
            'Varun',
            style: GoogleFonts.dancingScript(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGallery() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.blueGrey],
            ).createShader(bounds),
            child: Text(
              'Memory Lane 📸',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.8, // Slightly taller than square
            ),
            itemCount: 16, // 2x8 = 16 photos
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 500 + (index * 100)),
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: index % 2 == 0
                        ? [Colors.blueGrey, Colors.blueGrey]
                        : [Colors.grey.shade300, Colors.grey.shade500],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (index % 2 == 0 ? Colors.blueAccent : Colors.grey)
                          .withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/img_${index + 1}.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.white],
            ).createShader(bounds),
            child: Text(
              '🎉 Wishing you all the happiness in the world! 🎉',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBouncingEmoji('🎈', 0),
              _buildBouncingEmoji('🎂', 200),
              _buildBouncingEmoji('🎁', 400),
              _buildBouncingEmoji('🎊', 600),
              _buildBouncingEmoji('🥳', 800),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingEmoji(String emoji, int delay) {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            10 * math.sin((_confettiController.value * 6.28) + (delay / 1000)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 35),
            ),
          ),
        );
      },
    );
  }
}

class ConfettiParticle {
  final double x;
  final double delay;
  final double duration;
  final Color color;

  ConfettiParticle({
    required this.x,
    required this.delay,
    required this.duration,
    required this.color,
  });
}