import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'birthday_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/bg4.png',
      'text': '''Khushi premi Varun ko meri traf se birthday Mubarak..

Bda msg likhte hua gay feel ho rha..😶‍🌫️ but thanks for being my yvka aastha ko childane wale partner 💪.. 

Ik kitna axe insan ho .. itna sa hoke bhi tulika ko dikhane ka dum rakhte ho 🔥

Agra ki shaan.. ev e-rickshaw to supercar maker.. Happy Birthday 🫂

Body bna kr pagal kr dena juniors ko 🤟
      
      ~Vaibhav''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''My dear Barun,
I take my earnest and best wishes to greet you with the best year ever of your life.
With endless sparks and auditorium aura.
With infinite EV Gyan ka Chod and unexplained weird jokes around us.
I wish you the most fantastic ever birthday —
Amazingly beautiful with gorgeous curly locks of yours that fall OH SO DELICATELY on your temple.
You are truly a gem, Barun.
Do u need a belt??

Hepy burthday and LOLs from Tulls 🍕🍕'''
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Happy Birthday Varun bhaiii 🥳
Bhagwaan tumhari saari wishes puri kare 
Tum mujhse itne pange lete ho jaise koi trophy milegi end mein 😭
Jab pehli baar mile the tab hi samajh aa gaya tha ye banda Agra ka hi hai mental upgrade ke saath 🤡
"Aarah aarah" bolke UK ka accent laane ki acting kar rahe the kya bhai? 😭
Aur haan tum bahut bade waale cartoon ho jis bande ne audi ki chair tak to di thi 😂 pr tumhari baatein itni bekaar hoti hain ki sach mein ro de koi 😭
Baaki birthday hai to khush rho maze kro heheehhehe

~Yuvikaaaaaaa''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Technocrats ke backbone ,cpbyte ka kaam jiske bina chlta hi nahi ,leetcode ke shenshah Varun ko janamdin ki shubhkamnaye

      ~aapka priye vivek chauhan''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Happy Birthday Varun bhai....
Just keep doing the things your way,
keep breaking the chairs , keep teasing yuvika, and sbse jruri
Apni belt tulika ko dikhate rehna..
Baaki ..I am always there for you...
Or last, mere liye Chocolate petha laana mt bhoolna 🥹
Enjoy your day Chad !!

~Sumit''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Happy bday Varun bhaii ❤️🎂….sada khush rho or rehne do…sada suhagan rho 🤚🏻…bhagwan aapki hrr manokamna puri kre 😇…hmesha aise hi hste rho or hsate rho…please hostel m hi rehna agle saal bhii 🥲…nhii to mere room ki chabi or hostel id kon dhundhega….🙁or mere ek baar bulane pr kon mere saath badminton khelne aayega vo bhii neend se uthkeee 🥺….stay happy and blessed 🧿 ….
LOL (Lots of Laughter) VARUN BHAII 😂 

~Aastha''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Happy birthday Varun bhai....
you are a leet choder 
khoob dsa kro khoob choding kro 
tum bohot acheh choder ho 
bhagwan kre is saal tum 1000+ leetcode question kro
May god bless you !!
Enjoy your day !! 🥳🥳🥳🥳🥳

~Shubham''',
    },
    {
      'image': 'assets/images/bg4.png',
      'text': '''Happy birthday Vorun bhoiii....
Wild card entry huuuu.... hehehehe

~Pratyush''',
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _confettiController = ConfettiController(duration: Duration(seconds: 1));

    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/happy-birthday-254480.mp3'));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _nextPage() {
    _confettiController.play();

    if (_currentIndex < onboardingData.length - 1) {
      _fadeController.reverse().then((_) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex++;
        });
        _fadeController.forward();
      });
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => BirthdayScreen(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.pink.shade100.withOpacity(0.7),
                  Colors.blue.shade100.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Floating balloons decoration
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.1,
            child: _buildBalloon(Colors.red, screenWidth * 0.1),
          ),
          Positioned(
            top: screenHeight * 0.1,
            right: screenWidth * 0.15,
            child: _buildBalloon(Colors.blue, screenWidth * 0.08),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.2,
            child: _buildBalloon(Colors.green, screenWidth * 0.12),
          ),

          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Background image with overlay
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(onboardingData[index]['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),

                  // Content
                  Center(
                    child: AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: EdgeInsets.all(25),
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.5,
                          minWidth: screenWidth * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.pinkAccent.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Birthday hat icon
                              Icon(
                                Icons.celebration,
                                color: Colors.pink,
                                size: 40,
                              ),
                              SizedBox(height: 15),
                              // Message text
                              Text(
                                onboardingData[index]['text']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _fadeController.forward(from: 0);
            },
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.06,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [
                Colors.pink,
                Colors.blue,
                Colors.yellow,
                Colors.purple,
                Colors.green,
              ],
            ),
          ),

          // Page indicator
          Positioned(
            bottom: screenHeight * 0.17,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onboardingData.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  expansionFactor: 4,
                  spacing: 8,
                  activeDotColor: Colors.pink,
                  dotColor: Colors.white,
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),

          // Next button
          Positioned(
            bottom: screenHeight * 0.07,
            left: screenWidth * 0.15,
            right: screenWidth * 0.15,
            child: SizedBox(
              height: screenHeight * 0.065,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shadowColor: Colors.pink.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentIndex == onboardingData.length - 1
                          ? "Celebrate 🎉"
                          : "Next",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
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

  Widget _buildBalloon(Color color, double size) {
    return Container(
      width: size,
      height: size * 1.2,
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _BalloonStringPainter(),
      ),
    );
  }
}

class _BalloonStringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(
      size.width / 2 + 10,
      size.height + 30,
      size.width / 2,
      size.height + 50,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}