import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    final score = args['score'] ?? 0;
    final total = args['total'] ?? 0;
    final correctAnswers = args['correctAnswers'] ?? 0;
    final bonusPoints = args['bonusPoints'] ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz terminé!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Votre score total: $score / ${total + bonusPoints}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              'Réponses correctes: $correctAnswers / $total',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Points bonus de rapidité: $bonusPoints',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 15),
            _getPerformanceMessage(correctAnswers, total, bonusPoints),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Welcome');
              },
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _getPerformanceMessage(int correctAnswers, int total, int bonus) {
    final percentage = (correctAnswers / total) * 100;
    String message;
    Color color;
    
    if (percentage >= 90) {
      message = 'Excellent! Vous êtes un champion!';
      color = Colors.green;
    } else if (percentage >= 70) {
      message = 'Très bien! Vous connaissez votre sujet!';
      color = Colors.lightGreen;
    } else if (percentage >= 50) {
      message = 'Pas mal! Continuez à vous améliorer!';
      color = Colors.orange;
    } else {
      message = 'Vous pouvez faire mieux! Réessayez!';
      color = Colors.red;
    }
    
    // Ajouter un message sur la rapidité
    String speedMessage = '';
    if (bonus > 20) {
      speedMessage = '\nEt vous êtes très rapide!';
    } else if (bonus > 10) {
      speedMessage = '\nVotre vitesse est bonne!';
    } else {
      speedMessage = '\nEssayez d\'être plus rapide la prochaine fois!';
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message + speedMessage,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}