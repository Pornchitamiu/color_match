import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MatchColorApp());
}

class MatchColorApp extends StatelessWidget {
  const MatchColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Color',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB39DDB),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF7FB),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF1F7),
              Color(0xFFF0EAFF),
              Color(0xFFE8F7FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.palette_rounded,
                    size: 100,
                    color: Color(0xFFB39DDB),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Match Color',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D5A91),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'เกมจับคู่สี ฝึกสมาธิและการสังเกต',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GamePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('เริ่มเล่นเกม'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatorPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_rounded),
                    label: const Text('ผู้จัดทำ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random random = Random();

  final List<Color> palette = const [
    Color(0xFFF48FB1),
    Color(0xFF81D4FA),
    Color(0xFFA5D6A7),
    Color(0xFFFFCC80),
    Color(0xFFCE93D8),
    Color(0xFFFF8A80),
    Color(0xFF80CBC4),
    Color(0xFFFFF176),
  ];

  List<Color> options = [];
  Color target = const Color(0xFFF48FB1);
  Timer? timer;
  int score = 0;
  int mistakes = 0;
  int seconds = 30;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    newRound();
    startTimer();
  }

  void newRound() {
  target = palette[random.nextInt(palette.length)];
  options = [
    target,
    Color.lerp(target, Colors.white, 0.10)!,
    Color.lerp(target, Colors.black, 0.10)!,
    Color.lerp(target, Colors.white, 0.22)!,
  ];
  options.shuffle(random);
}

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (seconds <= 1) {
          seconds = 0;
          gameOver = true;
          t.cancel();
        } else {
          seconds--;
        }
      });
    });
  }

  void chooseColor(Color color) {
    if (gameOver) return;

    setState(() {
      if (color == target) {
        score++;
        newRound();
      } else {
        mistakes++;
        if (mistakes >= 3) {
          gameOver = true;
          timer?.cancel();
        }
      }
    });
  }

  void restartGame() {
    timer?.cancel();
    setState(() {
      score = 0;
      mistakes = 0;
      seconds = 30;
      gameOver = false;
      newRound();
    });
    startTimer();
  }

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF9575CD)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Color'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF1F7),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  statCard('เวลา', '$seconds', Icons.timer_rounded),
                  const SizedBox(width: 8),
                  statCard('คะแนน', '$score', Icons.star_rounded),
                  const SizedBox(width: 8),
                  statCard('ตอบผิด', '$mistakes/3', Icons.favorite_rounded),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'เลือกสีให้ตรงกับสีเป้าหมาย!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 190,
                height: 125,
                decoration: BoxDecoration(
                  color: target,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 5),
                ),
              ),
              const SizedBox(height: 24),
              if (gameOver) ...[
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 65,
                  color: Color(0xFFFFC857),
                ),
                const Text(
                  'จบเกมแล้ว!',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'คะแนนของคุณ: $score',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: restartGame,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('เริ่มเกมใหม่'),
                ),
              ] else ...[
                const Text('เลือกหนึ่งใน 4 สีด้านล่าง'),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.45,
                  children: options.map((color) {
                    return Material(
                      color: color,
                      borderRadius: BorderRadius.circular(22),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => chooseColor(color),
                        child: const Center(
                          child: Icon(
                            Icons.touch_app_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'ตอบผิดครบ 3 ครั้งหรือหมดเวลา เกมจะจบลง',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatorPage extends StatelessWidget {
  const CreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผู้จัดทำ'),
        backgroundColor: const Color(0xFFF0EAFF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.palette_rounded,
                size: 85,
                color: Color(0xFFB39DDB),
              ),
              const SizedBox(height: 20),
              const Text(
                'Match Color',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D5A91),
                ),
              ),
              const SizedBox(height: 12),
              const Text('ชื่อผู้จัดทำ: นางสาวพรชิตา ชั่งทอง'),
              const SizedBox(height: 8),
              const Text('รหัสนักศึกษา: 016830641003-1'),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home_rounded),
                label: const Text('กลับหน้าหลัก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
