import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/addressRepository.dart';
class Address {
 final String id;
 final String userId;
 final String? label;
 final String fullAddress;
 final double? lat;
 final double? lng;
 final bool isDefault;
 Address({required this.id, required this.userId, this.label, required this.fullAddress, this.lat, this.lng, this.isDefault = false});
 factory Address.fromMap(Map<String, dynamic> map) {
  return Address(id: map['id'] as String, userId: map['userId'] as String, label: map['label'] as String?, fullAddress: (map['fullAddress'] as String?) ?? '', lat: map['lat'] as double?, lng: map['lng'] as double?, isDefault: (map['isDefault'] as int?) == 1);
 }
}
class AddressNotifier extends FamilyAsyncNotifier<List<Address>, String> {
 late final AddressRepository _repository;
 late final String _argUserId;
 @override
 Future<List<Address>> build(String arg) async {
  _repository = AddressRepository();
  _argUserId = arg;
  return _loadAddresses();
 }
 Future<List<Address>> _loadAddresses() async {
  final addressesData = await _repository.getAddresses(_argUserId);
  return addressesData.map((data) => Address.fromMap(data)).toList();
 }
 Future<Address?> getDefaultAddress() async {
  try {
   final addressData = await _repository.getDefaultAddress(_argUserId);
   if (addressData != null) {
    return Address.fromMap(addressData);
   }
   return null;
  } catch (e) {
   return null;
  }
 }
 Future<void> addAddress({String? label, required String fullAddress, double? lat, double? lng, bool isDefault = false}) async {
  try {
   await _repository.addAddress(userId: _argUserId, label: label, fullAddress: fullAddress, lat: lat, lng: lng, isDefault: isDefault);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadAddresses());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> updateAddress(String addressId, Map<String, dynamic> updates) async {
  try {
   await _repository.updateAddress(addressId, updates);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadAddresses());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> deleteAddress(String addressId) async {
  try {
   await _repository.deleteAddress(addressId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadAddresses());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<void> setDefaultAddress(String addressId) async {
  try {
   await _repository.setDefaultAddress(_argUserId, addressId);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadAddresses());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
}
final addressProvider = AsyncNotifierProvider.family<AddressNotifier, List<Address>, String>(() {
 return AddressNotifier();
});