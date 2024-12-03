import 'package:flutter/cupertino.dart';
import 'package:usersbyd_app/models/address_model.dart';

class AppInfo extends ChangeNotifier
{
  AddressModel? pickupLocation;
  AddressModel? dropOfLocation;

  void updatePickUpLocation(AddressModel pickUpModel)
  {
   pickupLocation = pickUpModel;
   notifyListeners();
  }

  void updateDropOfLocation(AddressModel dropOfModel)
  {
    pickupLocation = dropOfModel;
    notifyListeners();
  }

}