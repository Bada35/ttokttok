import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdjustmentProcessPage extends StatefulWidget {
  const AdjustmentProcessPage({super.key});

  @override
  State<AdjustmentProcessPage> createState() => _AdjustmentProcessPageState();
}

class _AdjustmentProcessPageState extends State<AdjustmentProcessPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isEqualDistribution = true;
  final Map<String, double> _individualAmounts = {};
  List<String> _participants = [];
  String _roomName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _roomName = args['roomName'] as String;
      _participants = List<String>.from(args['participants'] as List);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _calculateEqualDistribution() {
    if (_amountController.text.isEmpty) return;
    double totalAmount = double.parse(_amountController.text);
    double perPerson =
        totalAmount / (_participants.length + 1); // +1 for the current user
    setState(() {
      _individualAmounts.clear();
      _individualAmounts['나'] = perPerson;
      for (var participant in _participants) {
        _individualAmounts[participant] = perPerson;
      }
    });
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
        title: Row(
          children: [
            Text(
              '정산하기(1차)',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: 차수 추가 기능 구현
              },
              child: const Text(
                '차수추가',
                style: TextStyle(
                  color: Color(0xFF22BE67),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF22BE67),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '1/N 하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _isEqualDistribution,
                            onChanged: (value) {
                              setState(() {
                                _isEqualDistribution = value;
                                if (_isEqualDistribution) {
                                  _calculateEqualDistribution();
                                }
                              });
                            },
                            activeColor: const Color(0xFF22BE67),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '금액입력(원)',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF22BE67)),
                  ),
                ),
                onChanged: (_) {
                  if (_isEqualDistribution) {
                    _calculateEqualDistribution();
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                '인원편집 ${_participants.length + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text('나', style: TextStyle(color: Colors.white)),
                      ),
                      title: const Text('나'),
                      trailing: _isEqualDistribution
                          ? Text(
                              '${_individualAmounts['나']?.toStringAsFixed(0) ?? 0}원')
                          : SizedBox(
                              width: 100,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  suffixText: '원',
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _individualAmounts['나'] =
                                        double.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                            ),
                    ),
                    ..._participants.map((participant) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(participant[0],
                                style: TextStyle(color: Colors.white)),
                          ),
                          title: Text(participant),
                          trailing: _isEqualDistribution
                              ? Text(
                                  '${_individualAmounts[participant]?.toStringAsFixed(0) ?? 0}원')
                              : SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                      suffixText: '원',
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _individualAmounts[participant] =
                                            double.tryParse(value) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('금액을 입력해주세요')),
                );
                return;
              }
              Navigator.pushNamed(
                context,
                '/adjustment-confirm',
                arguments: {
                  'roomName': _roomName,
                  'totalAmount': double.parse(_amountController.text),
                  'participants': _participants,
                  'individualAmounts': _individualAmounts,
                },
              );
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
              '확인',
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
