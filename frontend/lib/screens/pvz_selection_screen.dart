import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../services/api_service.dart';

class PvzSelectionScreen extends ConsumerStatefulWidget {
  const PvzSelectionScreen({super.key});

  @override
  ConsumerState<PvzSelectionScreen> createState() => _PvzSelectionScreenState();
}

class _PvzSelectionScreenState extends ConsumerState<PvzSelectionScreen> {
  List<dynamic> _pvzList = [];
  bool _isLoading = true;
  int? _selectedPvzId;

  @override
  void initState() {
    super.initState();
    _loadPvzList();
  }

  Future<void> _loadPvzList() async {
    try {
      final pvzList = await ApiService.getPvzList();
      setState(() {
        _pvzList = pvzList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки ПВЗ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите ПВЗ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pvzList.isEmpty
              ? const Center(child: Text('Нет доступных ПВЗ'))
              : ListView.builder(
                  itemCount: _pvzList.length,
                  itemBuilder: (context, index) {
                    final pvz = _pvzList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      color: _selectedPvzId == pvz['id'] ? Colors.blue[50] : null,
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(pvz['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pvz['address']),
                            Text('Режим работы: ${pvz['working_hours']}'),
                            _buildServiceIcons(pvz),
                          ],
                        ),
                        onTap: () {
                          setState(() => _selectedPvzId = pvz['id']);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: _selectedPvzId != null
          ? FloatingActionButton.extended(
              onPressed: () {
                ref.read(orderProvider.notifier).updateOrder(pvzId: _selectedPvzId);
                Navigator.pushNamed(context, '/order-confirmation');
              },
              icon: const Icon(Icons.check),
              label: const Text('Подтвердить ПВЗ'),
            )
          : null,
    );
  }

  Widget _buildServiceIcons(Map<String, dynamic> pvz) {
    final List<Widget> icons = [];
    if (pvz['accepts_tech'] == true) {
      icons.add(const Text('📱 '));
    }
    if (pvz['accepts_clothing'] == true) {
      icons.add(const Text('👔 '));
    }
    if (pvz['accepts_shoes'] == true) {
      icons.add(const Text('👟 '));
    }
    
    return Row(children: icons);
  }
}