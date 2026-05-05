import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class QuizListScreen extends StatefulWidget {
  final String type;

  const QuizListScreen({super.key, required this.type});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchQuiz(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Quiz ${widget.type}")),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: prov.quizList.length,
              itemBuilder: (context, index) {
                final quiz = prov.quizList[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(quiz['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz['description'] ?? ''),
                        const SizedBox(height: 4),

                        // 🔥 STATUS
                        Text(
                          quiz['is_finished']
                              ? "🔒 Sudah selesai"
                              : "🟢 Belum dikerjakan",
                          style: TextStyle(
                            color: quiz['is_finished']
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),

                    onTap: quiz['is_finished']
                        ? null
                        : () async {
                            final prov = context.read<QuizProvider>();

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(
                                  quizId: quiz['id'],
                                  title: quiz['title'],
                                ),
                              ),
                            );

                            if (!mounted) return;

                            if (result == true) {
                              await prov.fetchQuiz(widget.type);
                            }
                          },
                  ),
                );
              },
            ),
    );
  }
}
