import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

class OrderNotifier extends StateNotifier<OrderCreate> {
  OrderNotifier() : super(OrderCreate());

  void updateOrder({
    ServiceType? serviceType,
    String? subcategory,
    String? description,
    List<String>? photos,
    double? priceLimit,
    int? pvzId,
    String? paymentMethod,
  }) {
    state = state.copyWith(
      serviceType: serviceType ?? state.serviceType,
      subcategory: subcategory ?? state.subcategory,
      description: description ?? state.description,
      photos: photos ?? state.photos,
      priceLimit: priceLimit ?? state.priceLimit,
      pvzId: pvzId ?? state.pvzId,
      paymentMethod: paymentMethod ?? state.paymentMethod,
    );
  }

  void reset() {
    state = OrderCreate();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderCreate>(
  (ref) => OrderNotifier(),
);