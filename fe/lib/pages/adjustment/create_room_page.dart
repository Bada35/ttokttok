import 'package:flutter/material.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final List<String> _selectedFriends = [];

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _selectFriends() {
    // TODO: 카카오톡 친구 선택 API 연동
    setState(() {
      _selectedFriends.add('친구 ${_selectedFriends.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방 만들기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 방 이름 입력
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: '방 이름',
                hintText: '방 이름을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 친구 선택 버튼
            ElevatedButton.icon(
              onPressed: _selectFriends,
              icon: const Icon(Icons.person_add),
              label: const Text('카카오톡 친구 선택'),
            ),
            const SizedBox(height: 16),

            // 선택된 친구 목록
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: _selectedFriends.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(_selectedFriends[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            _selectedFriends.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // 방 생성 버튼
            ElevatedButton(
              onPressed: () {
                if (_roomNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('방 이름을 입력해주세요')),
                  );
                  return;
                }
                if (_selectedFriends.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('친구를 선택해주세요')),
                  );
                  return;
                }
                // TODO: 방 생성 로직 구현
                Navigator.pushNamed(context, '/adjustment-process');
              },
              child: const Text('방 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
