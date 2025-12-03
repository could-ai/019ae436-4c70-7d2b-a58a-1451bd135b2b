import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BungeeApp());
}

class BungeeApp extends StatelessWidget {
  const BungeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bungee Jump Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BungeeHomePage(),
      },
    );
  }
}

class BungeeHomePage extends StatefulWidget {
  const BungeeHomePage({super.key});

  @override
  State<BungeeHomePage> createState() => _BungeeHomePageState();
}

class _BungeeHomePageState extends State<BungeeHomePage> {
  // Game Constants
  final int _height = 100;

  // Game State
  String _statusMessage = "Ready to Jump?";
  String _detailedResult = "";
  bool _isGameOver = false;
  bool _hasJumped = false;
  Color _statusColor = Colors.black87;
  IconData _statusIcon = Icons.height;

  void _jump() {
    setState(() {
      _hasJumped = true;
      _isGameOver = true;

      // Game Logic from C code
      // ropeLength = (rand() % 40) + 60; // random length 60–100
      final random = Random();
      int ropeLength = random.nextInt(40) + 60; 

      // Logic: if (height > ropeLength)
      // Since height is 100 and ropeLength is 60-99, this is always true in this implementation
      // But we will keep the logic structure generic just in case.
      
      if (_height > ropeLength) {
        int fall = _height - ropeLength;
        // bounce = rand() % 2;
        int bounce = random.nextInt(2);

        if (bounce == 1) {
          // Survived
          _statusMessage = "You Bounced Safely! 😄";
          _detailedResult = "Height: $_height m\nRope Length: $ropeLength m\nFall Distance: $fall m\n\nResult: The rope held! You survived!";
          _statusColor = Colors.green;
          _statusIcon = Icons.sentiment_very_satisfied;
        } else {
          // Snapped
          _statusMessage = "The Rope Snapped! 😵";
          _detailedResult = "Height: $_height m\nRope Length: $ropeLength m\nFall Distance: $fall m\n\nResult: The rope couldn't take the strain. Game Over!";
          _statusColor = Colors.red;
          _statusIcon = Icons.sentiment_very_dissatisfied;
        }
      } else {
        // Rope too long (Unreachable with current random range 60-99 vs 100 height, but good for completeness)
        _statusMessage = "Rope Too Long! 💀";
        _detailedResult = "Height: $_height m\nRope Length: $ropeLength m\n\nResult: You hit the ground before the rope caught you.";
        _statusColor = Colors.red[900]!;
        _statusIcon = Icons.mood_bad;
      }
    });
  }

  void _resetGame() {
    setState(() {
      _hasJumped = false;
      _isGameOver = false;
      _statusMessage = "Ready to Jump?";
      _detailedResult = "";
      _statusColor = Colors.black87;
      _statusIcon = Icons.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bungee Jump Console Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Game',
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Status Icon
              Icon(
                _statusIcon,
                size: 100,
                color: _statusColor,
              ),
              const SizedBox(height: 20),
              
              // Main Status Text
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Game Info Card
              if (!_hasJumped)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Starting Height: $_height m", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        const Text("Rope Length: ??? (Hidden)", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),

              if (_hasJumped)
                Card(
                  elevation: 4,
                  color: _statusColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _detailedResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              const SizedBox(height: 50),

              // Action Button
              if (!_isGameOver)
                SizedBox(
                  width: 200,
                  height: 60,
                  child: FilledButton.icon(
                    onPressed: _jump,
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text("JUMP!", style: TextStyle(fontSize: 24)),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 200,
                  height: 60,
                  child: OutlinedButton.icon(
                    onPressed: _resetGame,
                    icon: const Icon(Icons.replay),
                    label: const Text("Play Again", style: TextStyle(fontSize: 20)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
