import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdjustmentProcessPage extends StatefulWidget {
  const AdjustmentProcessPage({super.key});

  @override
  State<AdjustmentProcessPage> createState() => _AdjustmentProcessPageState();
}

class _AdjustmentProcessPageState extends State<AdjustmentProcessPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  late TabController _tabController;
  final bool _isEqualDistribution = true;
  final Map<String, double> _individualAmounts = {};
  List<String> _participants = [];
  String _roomName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _tabController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

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
      backgroundColor: const Color(0xFFF1F3F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F3F5),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/back_button.svg'),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              '정산하기(1차)',
              style: TextStyle(
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(28), // 카드 바깥쪽 여백
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF333D48), // 선택/미선택 색상 통일
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: const Color(0xFF333D48),
                    indicatorColor: const Color(0xFF333D48),
                    indicatorSize:
                        TabBarIndicatorSize.label, // 인디케이터를 텍스트 길이만큼만
                    isScrollable: true, // 스크롤 가능하게 해서 왼쪽 정렬 가능
                    padding: EdgeInsets.zero, // 패딩 제거
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0), // 탭 사이 간격 조정
                    indicator: const UnderlineTabIndicator(
                      // 직선 인디케이터
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF333D48),
                      ),
                    ),
                    dividerColor: Colors.transparent, // 탭바 밑줄 제거
                    tabs: const [
                      Tab(text: '1/N 하기'),
                      Tab(text: '직접입력'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: '금액입력(원)',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(176, 184, 193, 0.7),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(176, 184, 193, 0.7)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF22BE67)),
                            ),
                          ),
                          onChanged: (_) {
                            if (_tabController.index == 0) {
                              _calculateEqualDistribution();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              '인원편집',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF737679),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_participants.length + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF737679),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Stack(
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text('나',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  title: Text(
                                    '나',
                                    style: const TextStyle(
                                      color: Color(0xFF282F37),
                                    ),
                                  ),
                                  trailing: _tabController.index == 0
                                      ? Text(
                                          '${_individualAmounts['나']?.toStringAsFixed(0) ?? 0}원')
                                      : SizedBox(
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
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
                                Positioned(
                                  top: 7,
                                  left: 37,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4E5968),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '나',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ..._participants.map((participant) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(participant[0],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  title: Text(
                                    participant,
                                    style: const TextStyle(
                                      color: Color(0xFF282F37),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: _tabController.index == 0
                                      ? Text(
                                          '${_individualAmounts[participant]?.toStringAsFixed(0) ?? 0}원')
                                      : SizedBox(
                                          width: 100,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: const InputDecoration(
                                              suffixText: '원',
                                              isDense: true,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _individualAmounts[
                                                        participant] =
                                                    double.tryParse(value) ?? 0;
                                              });
                                            },
                                          ),
                                        ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
