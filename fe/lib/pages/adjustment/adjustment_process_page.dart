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
  final List<String> _participants = ['나', '친구1', '친구2']; // 임시 데이터

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _calculateEqualDistribution() {
    if (_amountController.text.isEmpty) return;

    double totalAmount = double.parse(_amountController.text);
    double perPerson = totalAmount / _participants.length;

    setState(() {
      for (var participant in _participants) {
        _individualAmounts[participant] = perPerson;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정산하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 총액 입력
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: '총 금액',
                hintText: '정산할 총 금액을 입력하세요',
                border: OutlineInputBorder(),
                suffixText: '원',
              ),
              onChanged: (_) {
                if (_isEqualDistribution) {
                  _calculateEqualDistribution();
                }
              },
            ),
            const SizedBox(height: 16),

            // 분배 방식 선택
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('1/N 하기'),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('직접 입력'),
                      ),
                    ],
                    selected: {_isEqualDistribution},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isEqualDistribution = newSelection.first;
                        if (_isEqualDistribution) {
                          _calculateEqualDistribution();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 참여자별 금액 입력/표시
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: _participants.length,
                  itemBuilder: (context, index) {
                    String participant = _participants[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(participant[0]),
                      ),
                      title: Text(participant),
                      trailing: _isEqualDistribution
                          ? Text(
                              '${_individualAmounts[participant]?.toStringAsFixed(0) ?? 0}원')
                          : SizedBox(
                              width: 120,
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
                    );
                  },
                ),
              ),
            ),

            // 확인 버튼
            ElevatedButton(
              onPressed: () {
                // TODO: 정산 데이터 저장 및 카카오톡 메시지 전송
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
