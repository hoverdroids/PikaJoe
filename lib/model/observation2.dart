class Observation2 {
  final String uid;//Unique ID in Firebase corresponding to a given observation
  final String observerUid;
  //final String observerFirstName;
  //final String observerLastName;
  //final String observerEmail;
  //TODO - position: https://fireship.io/lessons/flutter-realtime-geolocation-firebase/
  //TODO was position manually entered?
  final String date;

  List<String> signs;
  String pikasDetected;
  String distanceToClosestPika;
  String searchDuration;
  String temperature;
  String skies;
  String wind;
  String siteHistory;
  String comments;
  List<String> imageUrls;
  List<String> audioUrls;
  List<String> otherAnimalsPresent;

  //TODO - image descriptions including isHayPile, isHayPile fresh/old/not sure, is scat...is fresh/old/not sure
  Observation2({
    this.uid,
    this.observerUid,
    //this.observerFirstName = "",
    //this.observerLastName = "",
    //this.observerEmail = "",
    this.date = "",
    this.signs = const [],
    this.pikasDetected = "",
    this.distanceToClosestPika = "",
    this.searchDuration = "",
    this.temperature = "",
    this.skies = "",
    this.wind = "",
    this.siteHistory = "",
    this.comments = "",
    this.imageUrls = const [],
    this.audioUrls = const [],
    this.otherAnimalsPresent = const []
  });

}
