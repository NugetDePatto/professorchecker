import 'package:flutter/material.dart';

class SubjectCarWidget extends StatelessWidget {
  final String classroom;
  final dynamic subject;

  const SubjectCarWidget({
    super.key,
    required this.classroom,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            classroom,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                //materia, titular, grupo, suplente, auxiliar
                Text(
                  subject.value['materia'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  subject.value['titular'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  subject.value['grupo'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
