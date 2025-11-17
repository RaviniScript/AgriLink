import 'package:flutter/material.dart';
import 'package:agri_link/models/order_model.dart';
import 'package:agri_link/repository/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OrderViewModel(this._orderRepository);

  Future<void> loadAllOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.getAllOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentOrder = await _orderRepository.getOrderById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = _orders.firstWhere((o) => o.id == orderId);
      final updatedOrder = OrderModel(
        id: order.id,
        buyerId: order.buyerId,
        farmerId: order.farmerId,
        items: order.items,
        totalAmount: order.totalAmount,
        status: newStatus,
        orderDate: order.orderDate,
        deliveryDate: order.deliveryDate,
        deliveryPersonId: order.deliveryPersonId,
      );
      await _orderRepository.updateOrder(updatedOrder);
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
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
