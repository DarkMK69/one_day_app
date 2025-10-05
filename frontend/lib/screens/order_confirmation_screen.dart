import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../services/api_service.dart';

class OrderConfirmationScreen extends ConsumerStatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  ConsumerState<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends ConsumerState<OrderConfirmationScreen> {
  bool _isLoading = false;
  String _paymentMethod = 'online';

  Future<void> _createOrder() async {
    setState(() => _isLoading = true);
    
    try {
      final order = ref.read(orderProvider);
      final orderData = order.toJson();
      
      final response = await ApiService.createOrder(orderData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ успешно создан!')),
      );
      
      // Переход к экрану с QR-кодом
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/order-success', 
        (route) => false,
        arguments: response,
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка создания заказа: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(orderProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение заказа'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сводка заказа:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOrderDetail('Тип услуги', _getServiceTypeName(order.serviceType)),
            _buildOrderDetail('Подкатегория', order.subcategory),
            _buildOrderDetail('Описание', order.description),
            if (order.priceLimit != null)
              _buildOrderDetail('Лимит цены', '${order.priceLimit} ₽'),
            const SizedBox(height: 20),
            const Text(
              'Способ оплаты:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('Онлайн'),
              value: 'online',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() => _paymentMethod = value!);
              },
            ),
            RadioListTile(
              title: const Text('Наличные в ПВЗ'),
              value: 'cash',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() => _paymentMethod = value!);
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createOrder,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Создать заказ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getServiceTypeName(ServiceType type) {
    switch (type) {
      case ServiceType.tech:
        return 'Техника';
      case ServiceType.clothing:
        return 'Одежда';
      case ServiceType.shoes:
        return 'Обувь';
    }
  }
}