import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usersbyd_app/appinfo/app_info.dart';
import 'package:usersbyd_app/global/global_var.dart';
import 'package:usersbyd_app/methods/common_methods.dart';
import 'package:usersbyd_app/models/address_model.dart';
import 'package:usersbyd_app/models/prediction_model.dart';

class PredictionPlaceUi extends StatefulWidget {
  PredictionModel? predictionPlaceData;
  PredictionPlaceUi({super.key, this.predictionPlaceData});

  @override
  State<PredictionPlaceUi> createState() => _PredictionPlaceUiState();
}

class _PredictionPlaceUiState extends State<PredictionPlaceUi> {
  fetchClickedPlaceDetails(String placeID) async {
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) => LoadingDialog(messageText:"Getting details...");
    // );
    String urlPlaceDetailsAPI =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyCw9MenAyGpa91Zpa2af6ZJr96GfjrdKA4";

    var responseFromPlaceDetailsAPI = await CommonMethods.sendRequestToAPI(urlPlaceDetailsAPI);


    if(responseFromPlaceDetailsAPI == "error")
    {
      return;
    }

    if(responseFromPlaceDetailsAPI["status"] == "OK")
    {

      AddressModel dropOffLocation = AddressModel();

      dropOffLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      dropOffLocation.latitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      dropOffLocation.longitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];

      dropOffLocation.placeID = placeID;
      
      Provider.of<AppInfo>(context, listen: false).updateDropOfLocation(dropOffLocation);

      Navigator.pop(context, "placeSelected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fetchClickedPlaceDetails(widget.predictionPlaceData!.place_id.toString());
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.share_location,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 13,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.predictionPlaceData!.main_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.predictionPlaceData!.secondary_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
