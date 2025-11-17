class DeliveryModel {
  final String id;
  final String orderId;
  final String deliveryPersonId;
  final String status; // 'pending', 'in_transit', 'delivered'
  final String? pickupLocation;
  final String? deliveryLocation;
  final DateTime assignedDate;
  final DateTime? completedDate;
  final double? latitude;
  final double? longitude;

  DeliveryModel({
    required this.id,
    required this.orderId,
    required this.deliveryPersonId,
    required this.status,
    this.pickupLocation,
    this.deliveryLocation,
    required this.assignedDate,
    this.completedDate,
    this.latitude,
    this.longitude,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      orderId: json['orderId'],
      deliveryPersonId: json['deliveryPersonId'],
      status: json['status'],
      pickupLocation: json['pickupLocation'],
      deliveryLocation: json['deliveryLocation'],
      assignedDate: DateTime.parse(json['assignedDate']),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'deliveryPersonId': deliveryPersonId,
      'status': status,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'assignedDate': assignedDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
