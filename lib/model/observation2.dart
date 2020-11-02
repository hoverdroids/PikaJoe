class Observation2 {
  String uid;
  final String observerUid;
  //TODO - position: https://fireship.io/lessons/flutter-realtime-geolocation-firebase/
  //TODO was position manually entered?
  String name;
  String location;
  DateTime date;
  List<String> signs;
  String pikasDetected;
  String distanceToClosestPika;
  String searchDuration;
  String talusArea;
  String temperature;
  String skies;
  String wind;
  List<String> otherAnimalsPresent;
  String siteHistory;
  String comments;
  List<String> imageUrls;
  List<String> audioUrls;

  //TODO - image descriptions including isHayPile, isHayPile fresh/old/not sure, is scat...is fresh/old/not sure
  Observation2({
    this.uid,
    this.observerUid,
    this.name = "",
    this.location = "",
    this.date,
    this.signs,
    this.pikasDetected = "",
    this.distanceToClosestPika = "",
    this.searchDuration = "",
    this.talusArea = "",
    this.temperature = "",
    this.skies = "",
    this.wind = "",
    this.siteHistory = "",
    this.comments = "",
    this.imageUrls,
    this.audioUrls,
    this.otherAnimalsPresent
  }){
    signs = signs == null ? <String>[] : signs;
    otherAnimalsPresent = otherAnimalsPresent == null ? <String>[] : otherAnimalsPresent;
    imageUrls = imageUrls == null ? <String>[] : imageUrls;
    audioUrls = audioUrls == null ? <String>[] : audioUrls;
  }

}
