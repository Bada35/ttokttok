import 'package:flutter/material.dart';

class AdjustmentConfirmPage extends StatefulWidget {
  const AdjustmentConfirmPage({super.key});

  @override
  State<AdjustmentConfirmPage> createState() => _AdjustmentConfirmPageState();
}

class _AdjustmentConfirmPageState extends State<AdjustmentConfirmPage> {
  String _roomName = '';
  double _totalAmount = 0;
  List<String> _participants = [];
  Map<String, double> _individualAmounts = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _roomName = args['roomName'] as String;
      _totalAmount = args['totalAmount'] as double;
      _participants = List<String>.from(args['participants'] as List);
      _individualAmounts =
          Map<String, double>.from(args['individualAmounts'] as Map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '최종 확인',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '총 ${_totalAmount.toStringAsFixed(0)}원(1차)',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text('나', style: TextStyle(color: Colors.white)),
                  ),
                  title: const Text('석유민'),
                  trailing: Text(
                    '${_individualAmounts['나']?.toStringAsFixed(0) ?? 0}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ..._participants.map((participant) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(participant[0],
                            style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(participant),
                      trailing: Text(
                        '${_individualAmounts[participant]?.toStringAsFixed(0) ?? 0}원',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                const Divider(height: 1),
                ListTile(
                  title: const Text(
                    '총 합계',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${_totalAmount.toStringAsFixed(0)}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/adjustment-complete');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22BE67),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              '요청하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
