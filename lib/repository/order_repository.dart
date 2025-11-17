import 'package:agri_link/models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderById(String id);
  Future<List<OrderModel>> getOrdersByBuyerId(String buyerId);
  Future<List<OrderModel>> getOrdersByFarmerId(String farmerId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<void> deleteOrder(String id);
}

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderModel>> getAllOrders() async {
    // TODO: Implement get all orders
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    // TODO: Implement get order by id
    throw UnimplementedError();
  }

  @override
  Future<List<OrderModel>> getOrdersByBuyerId(String buyerId) async {
    // TODO: Implement get orders by buyer id
    throw UnimplementedError();
  }

  @override
  Future<List<OrderModel>> getOrdersByFarmerId(String farmerId) async {
    // TODO: Implement get orders by farmer id
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    // TODO: Implement create order
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    // TODO: Implement update order
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOrder(String id) async {
    // TODO: Implement delete order
    throw UnimplementedError();
  }
}
