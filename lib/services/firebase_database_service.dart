import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pika_joe/model/observation2.dart';
import 'package:pika_joe/model/user_profile.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class FirebaseDatabaseService {

  final String uid;

  FirebaseDatabaseService({ this.uid });

  final CollectionReference userProfilesCollection = Firestore.instance.collection("userProfiles");

  final CollectionReference observationsCollection = Firestore.instance.collection("observations");

  Future updateUserProfile(
    String firstName,
    String lastName,
    String tagline,
    String pronouns,
    String organization,
    String address,
    String city,
    String state,
    String zip,
    bool frppOptIn,
    bool rmwOptIn,
    bool dzOptIn
  ) async {
    return await userProfilesCollection.document(uid).setData(
        {
          'firstName': firstName,
          'lastName': lastName,
          'tagline' : tagline,
          'pronouns': pronouns,
          'organization': organization,
          'address': address,
          'city': city,
          'state': state,
          'zip': zip,
          'frppOptIn': frppOptIn,
          'rmwOptIn': rmwOptIn,
          'dzOptIn': dzOptIn,
        }
    );
  }
  
  /*Future updateUserProfile(UserProfile data) async {
    return await userProfilesCollection.document(uid).setData(
        {
          'firstName': data.firstName,
          'lastName': data.lastName,
          'pronouns': data.pronouns,
          'organization': data.organization,
          'address': data.address,
          'city': data.city,
          'state': data.state,
          'zip': data.zip,
          'frppOptIn': data.frppOptIn,
          'rmwOptIn': data.rmwOptIn,
          'dzOptIn': data.dzOptIn,
        }
    );
  }*/

  UserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    return UserProfile(
      snapshot.data['firstName'] ?? '',
      snapshot.data['lastName'] ?? '',
      uid: uid,
      tagline: snapshot.data['tagline'] ?? '',
      pronouns: snapshot.data['pronouns'] ?? '',
      organization: snapshot.data['organization'] ?? '',
      address: snapshot.data['address'] ?? '',
      city: snapshot.data['city'] ?? '',
      state: snapshot.data['state'] ?? '',
      zip: snapshot.data['zip'] ?? '',
      frppOptIn: snapshot.data['frppOptIn'] ?? false,
      rmwOptIn: snapshot.data['rmwOptIn'] ?? false,
      dzOptIn: snapshot.data['dzOptIn'] ?? false,
    );
  }

  Stream<UserProfile> get userProfile {
    return uid == null ? null : userProfilesCollection.document(uid).snapshots().map(_userProfileFromSnapshot);
  }

  Future updateObservation(Observation2 observation) async {
    //if no ID, the id and timestamp are auto gen; not sure it's what we want
    var doc = observation.uid == null ? observationsCollection.document() : observationsCollection.document(observation.uid);
    observation.uid = doc.documentID;
    return await doc.setData(
        {
          'observerUid': observation.observerUid,
          'name': observation.name,
          'location': observation.location,
          'date': observation.date,
          //'geo' : null,
          'signs': observation.signs,
          'pikasDetected': observation.pikasDetected,
          'distanceToClosestPika': observation.distanceToClosestPika,
          'searchDuration': observation.searchDuration,
          'talusArea': observation.talusArea,
          'temperature': observation.temperature,
          'skies': observation.skies,
          'wind': observation.wind,
          'siteHistory': observation.siteHistory,
          'comments': observation.comments,
          'imageUrls': observation.imageUrls,
          'audioUrls': observation.audioUrls
        }
    );
  }

  List<Observation2> _observationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {

      List<dynamic> urls = doc.data['imageUrls'];//.Cast<String>().ToList();
      List<String> imageUrls = urls.cast<String>().toList();

      print("ImageUrls: ${doc.data['imageUrls'][0]}");

      return Observation2(
        uid: doc.documentID ?? '',
        observerUid: doc.data['observerUid'] ?? '',
        name: doc.data['name'] ?? '',
        location: doc.data['location'] ?? '',
        //date: doc.data['date'] ?? '',
        //signs: doc.data['signs'] ?? <String>[],
        pikasDetected: doc.data['pikasDetected'] ?? '',
        distanceToClosestPika: doc.data['distanceToClosestPika'] ?? '',
        searchDuration: doc.data['searchDuration'] ?? '',
        talusArea: doc.data['talusArea'] ?? '',
        temperature: doc.data['temperature'] ?? '',
        skies: doc.data['skies'] ?? '',
        wind: doc.data['wind'] ?? '',
        siteHistory: doc.data['siteHistory'] ?? '',
        comments: doc.data['comments'] ?? '',
        imageUrls: imageUrls ?? <String>[]
      );
    }).toList();
  }

  Stream<List<Observation2>> get observations {
    return observationsCollection.snapshots().map(_observationsFromSnapshot);
  }

  Future<List<String>> uploadFiles(List<String> filepaths, bool areImages) async {
    List<String> uploadUrls = [];

    await Future.wait(filepaths.map((String filepath) async {
      //TODO - base on mime
      /*String mimeStr = lookupMimeType(filepath);
      var fileType = mimeStr.split('/');
      print('file type ${fileType}');*/
      var folder = areImages ? "images" : "audio";
      if(filepath.contains('pikajoe-97c5c.appspot.com')) {
        //Do not try to upload an image that has already been uploaded
        uploadUrls.add(filepath);
      } else {
        FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://pikajoe-97c5c.appspot.com');
        StorageUploadTask uploadTask = storage.ref().child("$folder/${basename(filepath)}").putFile(File(filepath));
        StorageTaskSnapshot storageTaskSnapshot;

        StorageTaskSnapshot snapshot = await uploadTask.onComplete;
        if (snapshot.error == null) {
          storageTaskSnapshot = snapshot;
          final String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
          uploadUrls.add(downloadUrl);

          print('Upload success');
        } else {
          print('Error from image repo ${snapshot.error.toString()}');
          throw ('This file is not an image');
        }
      }
    }), eagerError: true, cleanUp: (_) {
      print('eager cleaned up');
    });

    return uploadUrls;
  }
}