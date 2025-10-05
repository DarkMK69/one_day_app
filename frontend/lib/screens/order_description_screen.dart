import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';

class OrderDescriptionScreen extends ConsumerStatefulWidget {
  const OrderDescriptionScreen({super.key});

  @override
  ConsumerState<OrderDescriptionScreen> createState() => _OrderDescriptionScreenState();
}

class _OrderDescriptionScreenState extends ConsumerState<OrderDescriptionScreen> {
  final _descriptionController = TextEditingController();
  final _priceLimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Описание проблемы'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Опишите проблему или пожелания',
                border: OutlineInputBorder(),
                hintText: 'Например: телефон не включается после падения...',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Сделайте 1-3 фото',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPhotoPlaceholder(),
                const SizedBox(width: 10),
                _buildPhotoPlaceholder(),
                const SizedBox(width: 10),
                _buildPhotoPlaceholder(),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _priceLimitController,
              decoration: const InputDecoration(
                labelText: 'Максимум готов платить (опционально)',
                border: OutlineInputBorder(),
                hintText: 'Например: 3000 ₽',
                prefixText: '₽ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ref.read(orderProvider.notifier).updateOrder(
                  description: _descriptionController.text,
                  priceLimit: double.tryParse(_priceLimitController.text),
                );
                Navigator.pushNamed(context, '/pvz-selection');
              },
              child: const Text('Далее'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.camera_alt, color: Colors.grey),
    );
  }
}