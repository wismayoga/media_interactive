import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  final String title;

  const QuizScreen({super.key, required this.quizId, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, String> jawaban = {}; // questionId : A/B/C/D
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchSoal(widget.quizId);
    });
  }

  void submit() async {
    final prov = context.read<QuizProvider>();

    if (jawaban.length != prov.questions.length) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Perhatian"),
          content: Text("Masih ada soal yang belum dijawab"),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final res = await prov.submitJawaban(widget.quizId, jawaban);

      // 🔥 WAJIB
      if (!mounted) return;

      final nilai = res['nilai'] ?? 0;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Hasil Quiz"),
          content: Text("Nilai kamu: $nilai"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.pop(context, true); // balik + refresh signal
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (!mounted) return;
    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),

      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prov.questions.isEmpty
          ? const Center(child: Text("Tidak ada soal"))
          : Column(
              children: [
                // 🔥 LIST SOAL
                Expanded(
                  child: ListView.builder(
                    itemCount: prov.questions.length,
                    itemBuilder: (context, index) {
                      final q = prov.questions[index];

                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ${q['question']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 🔥 OPTIONS
                              ...[
                                {"key": "option_a", "label": "A"},
                                {"key": "option_b", "label": "B"},
                                {"key": "option_c", "label": "C"},
                                {"key": "option_d", "label": "D"},
                              ].map((opt) {
                                return RadioListTile<String>(
                                  value: opt['label']!,
                                  groupValue: jawaban[q['id']],
                                  onChanged: (val) {
                                    setState(() {
                                      jawaban[q['id']] = val!;
                                    });
                                  },
                                  title: Text(
                                    "${opt['label']}. ${q[opt['key']]}",
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔥 BUTTON SUBMIT
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : submit,
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Kirim Jawaban"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
