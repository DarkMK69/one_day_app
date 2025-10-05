import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите категорию'),
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
            _buildCategoryCard(
              context: context,
              icon: '📱',
              title: 'Техника',
              subtitle: 'Ремонт устройств',
              serviceType: ServiceType.tech,
              subcategories: const ['Смартфон', 'Ноутбук', 'Бытовая техника'],
            ),
            const SizedBox(height: 16),
            _buildCategoryCard(
              context: context,
              icon: '👔',
              title: 'Одежда',
              subtitle: 'Химчистка и ремонт',
              serviceType: ServiceType.clothing,
              subcategories: const ['Пальто', 'Костюм', 'Платье'],
            ),
            const SizedBox(height: 16),
            _buildCategoryCard(
              context: context,
              icon: '👟',
              title: 'Обувь',
              subtitle: 'Чистка и ремонт',
              serviceType: ServiceType.shoes,
              subcategories: const ['Кроссовки', 'Туфли', 'Сапоги'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required ServiceType serviceType,
    required List<String> subcategories,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showSubcategoryDialog(
            context: context,
            ref: ProviderScope.containerOf(context),
            serviceType: serviceType,
            subcategories: subcategories,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubcategoryDialog({
    required BuildContext context,
    required WidgetRef ref,
    required ServiceType serviceType,
    required List<String> subcategories,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выберите тип ${_getCategoryName(serviceType)}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: subcategories.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(_getSubcategoryIcon(serviceType, subcategories[index])),
              title: Text(subcategories[index]),
              onTap: () {
                Navigator.pop(context);
                // Сохраняем выбранную категорию и переходим дальше
                ref.read(orderProvider.notifier).updateOrder(
                  serviceType: serviceType,
                  subcategory: subcategories[index],
                );
                Navigator.pushNamed(context, '/order-description');
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryName(ServiceType type) {
    switch (type) {
      case ServiceType.tech:
        return 'техники';
      case ServiceType.clothing:
        return 'одежды';
      case ServiceType.shoes:
        return 'обуви';
    }
  }

  IconData _getSubcategoryIcon(ServiceType type, String subcategory) {
    // Упрощённая логика иконок
    return Icons.category;
  }
}