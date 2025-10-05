enum ServiceType { tech, clothing, shoes }

class OrderCreate {
  final int userId;
  final int pvzId;
  final ServiceType serviceType;
  final String subcategory;
  final String description;
  final List<String> photos;
  final double? priceLimit;
  final String paymentMethod;

  OrderCreate({
    required this.userId,
    required this.pvzId,
    required this.serviceType,
    required this.subcategory,
    required this.description,
    required this.photos,
    this.priceLimit,
    this.paymentMethod = 'online',
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'pvz_id': pvzId,
      'service_type': serviceType.name,
      'subcategory': subcategory,
      'description': description,
      'photos': photos,
      'price_limit': priceLimit,
      'payment_method': paymentMethod,
    };
  }

  OrderCreate copyWith({
    int? userId,
    int? pvzId,
    ServiceType? serviceType,
    String? subcategory,
    String? description,
    List<String>? photos,
    double? priceLimit,
    String? paymentMethod,
  }) {
    return OrderCreate(
      userId: userId ?? this.userId,
      pvzId: pvzId ?? this.pvzId,
      serviceType: serviceType ?? this.serviceType,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      priceLimit: priceLimit ?? this.priceLimit,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}