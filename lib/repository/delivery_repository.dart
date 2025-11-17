import 'package:agri_link/models/delivery_model.dart';

abstract class DeliveryRepository {
  Future<List<DeliveryModel>> getAllDeliveries();
  Future<DeliveryModel> getDeliveryById(String id);
  Future<List<DeliveryModel>> getDeliveriesByPersonId(String personId);
  Future<DeliveryModel> createDelivery(DeliveryModel delivery);
  Future<DeliveryModel> updateDelivery(DeliveryModel delivery);
  Future<void> deleteDelivery(String id);
}

class DeliveryRepositoryImpl implements DeliveryRepository {
  @override
  Future<List<DeliveryModel>> getAllDeliveries() async {
    // TODO: Implement get all deliveries
    throw UnimplementedError();
  }

  @override
  Future<DeliveryModel> getDeliveryById(String id) async {
    // TODO: Implement get delivery by id
    throw UnimplementedError();
  }

  @override
  Future<List<DeliveryModel>> getDeliveriesByPersonId(String personId) async {
    // TODO: Implement get deliveries by person id
    throw UnimplementedError();
  }

  @override
  Future<DeliveryModel> createDelivery(DeliveryModel delivery) async {
    // TODO: Implement create delivery
    throw UnimplementedError();
  }

  @override
  Future<DeliveryModel> updateDelivery(DeliveryModel delivery) async {
    // TODO: Implement update delivery
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDelivery(String id) async {
    // TODO: Implement delete delivery
    throw UnimplementedError();
  }
}
