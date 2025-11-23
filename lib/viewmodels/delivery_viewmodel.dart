import 'package:flutter/material.dart';
import 'package:agri_link/models/delivery_model.dart';
import 'package:agri_link/models/order_model.dart';
import 'package:agri_link/repository/delivery_repository.dart';
import 'package:agri_link/repository/order_repository.dart';

class DeliveryViewModel extends ChangeNotifier {
  final DeliveryRepository _deliveryRepository;
  final OrderRepository _orderRepository;

  List<DeliveryModel> _deliveries = [];
  final List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DeliveryModel> get deliveries => _deliveries;
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DeliveryViewModel(this._deliveryRepository, this._orderRepository);

  Future<void> loadDeliveries(String personId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _deliveries = await _deliveryRepository.getDeliveriesByPersonId(personId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateDeliveryLocation(String deliveryId, double latitude, double longitude) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final delivery = _deliveries.firstWhere((d) => d.id == deliveryId);
      final updatedDelivery = DeliveryModel(
        id: delivery.id,
        orderId: delivery.orderId,
        deliveryPersonId: delivery.deliveryPersonId,
        status: delivery.status,
        pickupLocation: delivery.pickupLocation,
        deliveryLocation: delivery.deliveryLocation,
        assignedDate: delivery.assignedDate,
        completedDate: delivery.completedDate,
        latitude: latitude,
        longitude: longitude,
      );
      await _deliveryRepository.updateDelivery(updatedDelivery);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeDelivery(String deliveryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final delivery = _deliveries.firstWhere((d) => d.id == deliveryId);
      final updatedDelivery = DeliveryModel(
        id: delivery.id,
        orderId: delivery.orderId,
        deliveryPersonId: delivery.deliveryPersonId,
        status: 'delivered',
        pickupLocation: delivery.pickupLocation,
        deliveryLocation: delivery.deliveryLocation,
        assignedDate: delivery.assignedDate,
        completedDate: DateTime.now(),
        latitude: delivery.latitude,
        longitude: delivery.longitude,
      );
      await _deliveryRepository.updateDelivery(updatedDelivery);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
