import 'package:flutter/material.dart';
import '../services/report_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OMNI-CLEAN',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  letterSpacing: 4,
                  color: Color(0xFF7C6FFF),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Your digital life\nis auto-optimized.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              FutureBuilder<ReportData>(
                future: ReportService().generateReport(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const CircularProgressIndicator(
                      color: Color(0xFF7C6FFF),
                    );
                  }
                  final r = snap.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statCard('Storage saved', '${r.mbSaved.toStringAsFixed(1)} MB'),
                      const SizedBox(height: 12),
                      _statCard('Subscriptions detected', '${r.subscriptionsDetected}'),
                      const SizedBox(height: 12),
                      _statCard('Files tagged', '${r.filesTagged}'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A3F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 4),
          Text(value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        ],
      ),
    );
  }
}