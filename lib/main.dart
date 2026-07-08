import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/activity_log.dart';
import 'services/firebase_service.dart';
import 'widgets/glass_components.dart';
import 'widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDWJIlBu5Pf_VwKRk_499Wdt0GeNXTzbog",
        appId: "1:842453929294:android:71d06690b18179fe1ce21f",
        messagingSenderId: "842453929294",
        projectId: "fitness-tracker-app-ffa53",
        storageBucket: "fitness-tracker-app-ffa53.appspot.com",
      ),
    );
    print("Firebase connected successfully!");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraFit Neo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF090D16),
          primary: Color(0xFF2DD4BF),       // Cyber Teal
          secondary: Color(0xFF10B981),     // Volt Mint
        ),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const AuraFitSplashScreen(),
    );
  }
}

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  // Using the newly renamed FitnessService class to avoid conflicts
  final FitnessService _fitnessService = FitnessService();
  final int _stepGoal = 10000;
  final int _calorieGoal = 2500;
  final int _currentSteps = 7130;

  void _logActivityDialog() {
    final typeController = TextEditingController();
    final durationController = TextEditingController();
    final caloriesController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827).withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: const Row(
          children: [
            Icon(Icons.fitness_center_rounded, color: Color(0xFF2DD4BF), size: 26),
            SizedBox(width: 12),
            Text('Log Workout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: typeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Exercise Type', Icons.directions_run_rounded, const Color(0xFF2DD4BF)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Duration (minutes)', Icons.timer_outlined, const Color(0xFF2DD4BF)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Calories Burned', Icons.local_fire_department_rounded, const Color(0xFF10B981)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          FilledButton(
            onPressed: () async {
              final String type = typeController.text.trim();
              final int? duration = int.tryParse(durationController.text);
              final int? calories = int.tryParse(caloriesController.text);

              if (type.isEmpty || duration == null || calories == null) return;

              await _fitnessService.addActivity(type, duration, calories);
              if (mounted) Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2DD4BF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Log', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, Color focusColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      prefixIcon: Icon(icon, size: 20, color: focusColor.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text(
          'AuraFit Pro',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5),
        ),
        actions: [
          TextButton.icon(
            onPressed: _logActivityDialog,
            icon: const Icon(Icons.add_box_rounded, size: 20, color: Color(0xFF2DD4BF)),
            label: const Text('Log Activity', style: TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -20, left: -30,
            child: Container(width: 220, height: 220, decoration:  BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2DD4BF).withOpacity(0.12))),
          ),
          Positioned(
            bottom: 200, right: -60,
            child: Container(width: 260, height: 260, decoration:  BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10B981).withOpacity(0.08))),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: _fitnessService.getActivitiesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Database connection error.'));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF2DD4BF)));

              final List<ActivityLog> loadedActivities = snapshot.data!.docs
                  .map((doc) => ActivityLog.fromFirestore(doc))
                  .toList();

              final int totalCaloriesBurned = loadedActivities.fold(0, (sum, item) => sum + item.calories);

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Formatted explicitly without any "const" markers up the row container branch
                      Row(
                        children: [
                          Expanded(
                            child: GlassMetricContainer(
                              title: "Steps Count",
                              valStr: "$_currentSteps",
                              goalStr: "Goal: $_stepGoal",
                              progress: _currentSteps / _stepGoal,
                              accentColor: const Color(0xFF2DD4BF),
                              icon: Icons.directions_walk_rounded,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GlassMetricContainer(
                              title: "Burned Energy",
                              valStr: "$totalCaloriesBurned kcal",
                              goalStr: "Goal: $_calorieGoal",
                              progress: (totalCaloriesBurned / _calorieGoal).clamp(0.0, 1.0),
                              accentColor: const Color(0xFF10B981),
                              icon: Icons.local_fire_department_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text('Weekly Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      const GlassWeeklyChartCard(),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Today's Workouts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text("${loadedActivities.length} logs active", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      loadedActivities.isEmpty
                          ? Container(
                        width: double.infinity, padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
                        child: Center(child: Text('No activities stored in cloud yet.', style: TextStyle(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w500))),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: loadedActivities.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => GlassActivityTile(log: loadedActivities[index]),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}