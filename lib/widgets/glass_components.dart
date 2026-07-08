import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/activity_log.dart';

class GlassMetricContainer extends StatelessWidget {
  final String title;
  final String valStr;
  final String goalStr;
  final double progress;
  final Color accentColor;
  final IconData icon;

  const GlassMetricContainer({
    super.key,
    required this.title,
    required this.valStr,
    required this.goalStr,
    required this.progress,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          // Fixed: Reduced padding slightly to prevent narrow screens from crushing content
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fixed: Added Flexible to prevent text pushing the icon off screen boundaries
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, size: 18, color: accentColor.withOpacity(0.6)),
                ],
              ),
              const SizedBox(height: 14),
              // Fixed: Wrapped with FittedBox so massive metrics shrink dynamically instead of blowing past edges
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(valStr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Text(goalStr, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassWeeklyChartCard extends StatelessWidget {
  const GlassWeeklyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> weeklyData = [0.4, 0.7, 0.9, 0.5, 0.8, 0.3, 0.65];
    final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Container(
                    height: 100,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100 * weeklyData[index],
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2DD4BF), Color(0xFF10B981)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(days[index], style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.bold)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class GlassActivityTile extends StatelessWidget {
  final ActivityLog log;
  const GlassActivityTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2DD4BF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt_rounded, color: Color(0xFF2DD4BF), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('${log.duration} mins workout', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                  ],
                ),
              ),
              Text(
                '+${log.calories} kcal',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}