import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  List<String> threads = [];

  void _addThread(String thread) {
    setState(() {
      threads.add(thread);
    });
  }

  Future<void> _createThread(String thread) async {
    var headers = {
      'Content-Type': 'multipart/form-data',
      'User-Agent': 'insomnia/8.5.0',
      'Authorization': 'Token 44f91df7464f18117c3b52d77cb054bbdf34ee0b'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://stuverse.shop/api/threads/'));

    request.headers.addAll(headers);
    request.fields.addAll({
      'content': thread,
    });
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        print('Thread created successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thread created successfully!'),
          ),
        );
      } else {
        print('Failed to create thread: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error creating thread: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread App'),
      ),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(threads[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await _navigateToAddThreadScreen(context);
          if (result != null) {
            _createThread(result);
            _addThread(result);
          }
        },
        tooltip: 'Add Thread',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _navigateToAddThreadScreen(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddThreadScreen()),
    );
  }
}

class AddThreadScreen extends StatelessWidget {
  final TextEditingController _threadController = TextEditingController();

  AddThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Thread'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _threadController,
              decoration: const InputDecoration(
                labelText: 'Enter Thread',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String thread = _threadController.text;
                Navigator.pop(context, thread);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
