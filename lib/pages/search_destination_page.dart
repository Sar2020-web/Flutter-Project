import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usersbyd_app/global/global_var.dart';
import 'package:usersbyd_app/methods/common_methods.dart';
import 'package:usersbyd_app/models/prediction_model.dart';
import 'package:usersbyd_app/widgets/prediction_place_ui.dart';

import '../appinfo/app_info.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();

  List<PredictionModel> dropOffPredictionsPlacesList = [];

  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      log(locationName.toString());
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=AIzaSyCw9MenAyGpa91Zpa2af6ZJr96GfjrdKA4&components=country:in";
      var responseFromPlaceAPI =
          await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlaceAPI == "error") {
        return;
      }
      if (responseFromPlaceAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlaceAPI["predictions"];
        var predictionsList = (predictionResultInJson as List)
            .map((eachPlaceprediction) =>
                PredictionModel.fromJson(eachPlaceprediction))
            .toList();
        log(predictionsList.toString());
        setState(() {
          dropOffPredictionsPlacesList = predictionsList;
        });

        // log("predictionResultInJson = " + predictionResultInJson.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userAddress = Provider.of<AppInfo>(context, listen: false)
            .pickupLocation!
            .humanReadableAddress ??
        "";
    pickupTextEditingController.text = userAddress;
    // log(userAddress);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Text(
                              "Destination Location",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //pickup code
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/initial.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: TextField(
                                  controller: pickupTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: "Pick Up Address",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11, top: 9, bottom: 9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      //destination code
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/final.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: TextField(
                                  controller: destinationTextEditingController,
                               onSubmitted: (inputtext){
                                    log(inputtext);
                                 searchLocation(inputtext);
                               },
                                  decoration: InputDecoration(
                                    hintText: "Destination Address",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11, top: 9, bottom: 9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Prediction Results

            (dropOffPredictionsPlacesList.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return PredictionPlaceUi(
                          predictionPlaceData:
                              dropOffPredictionsPlacesList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 2,
                      ),
                      itemCount: dropOffPredictionsPlacesList.length,
                      shrinkWrap: true,
                      physics:  ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
