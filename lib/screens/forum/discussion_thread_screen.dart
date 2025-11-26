import 'package:flutter/material.dart';

class DiscussionThreadScreen extends StatefulWidget {
  const DiscussionThreadScreen({super.key});

  @override
  State<DiscussionThreadScreen> createState() => _DiscussionThreadScreenState();
}

class _DiscussionThreadScreenState extends State<DiscussionThreadScreen> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diskusi: Algoritma Sorting'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildPost(
                  'Ahmad',
                  'Apakah ada yang bisa menjelaskan bubble sort dengan lebih detail?',
                  '2 jam yang lalu',
                  isOriginal: true,
                ),
                _buildPost(
                  'Siti',
                  'Bubble sort adalah algoritma sorting sederhana yang bekerja dengan membandingkan elemen bersebelahan.',
                  '1 jam yang lalu',
                ),
                _buildPost(
                  'Budi',
                  'Terima kasih penjelasannya. Bagaimana dengan time complexity-nya?',
                  '30 menit yang lalu',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis balasan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Send reply
                    setState(() {
                      _replyController.clear();
                    });
                  },
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(String name, String message, String time, {bool isOriginal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(name[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(message),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}