class AddressModel {
  final String addressType;
  final Address address;

  AddressModel({required this.addressType, required this.address});

  Map<String, dynamic> toJson() {
    return {
      "addressType": addressType,
      "address": address.toJson(),
    };
  }
}

class Address {
  final String houseNumber;
  final String landmark;
  final String state;
  final String city;
  final String pinCode;
  final String country;
  final String fullAddress;

  Address({
    required this.houseNumber,
    required this.landmark,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.country,
    required this.fullAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "houseNumber": houseNumber,
      "landmark": landmark,
      "state": state,
      "city": city,
      "pinCode": pinCode,
      "country": country,
      "fullAddress": fullAddress,
    };
  }
}
