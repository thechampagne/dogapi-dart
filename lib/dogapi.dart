/// Dog API client.
library dogapi;

import 'dart:convert';
import 'dart:io';

class DogAPIException implements Exception {

  late String _message;

  DogAPIException(String message) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

Future<String> _getRequest(String endpoint) async {
  Uri uri = Uri.parse("https://dog.ceo/api/${endpoint}");
  var request = await new HttpClient().getUrl(uri);
  var response = await request.close();

  var stream = response.transform(Utf8Decoder());

  String content = "";

  await for (var i in stream) {
    content += i;
  }
  return content;
}

/// DISPLAY SINGLE RANDOM IMAGE FROM ALL DOGS COLLECTION
///
/// Returns a random dog image
Future<String> randomImage() async {
  try {
    var response = await _getRequest("breeds/image/random");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    return json["message"];
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// DISPLAY MULTIPLE RANDOM IMAGES FROM ALL DOGS COLLECTION
///
/// * `imagesNumber` number of images
///
/// *NOTE* ~ Max number returned is 50
///
/// Return multiple random dog image
Future<List<String>> multipleRandomImages(int imagesNumber) async {
  try {
    var response = await _getRequest("breeds/image/random/${imagesNumber}");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// RANDOM IMAGE FROM A BREED COLLECTION
///
/// * `breed` breed name
///
/// Returns a random dog image from a breed, e.g. hound
Future<String> randomImageByBreed(String breed) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/images/random");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    return json["message"];
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// MULTIPLE IMAGES FROM A BREED COLLECTION
///
/// * `breed` breed name
/// * `imagesNumber` number of images
///
/// Return multiple random dog image from a breed, e.g. hound
Future<List<String>> multipleRandomImagesByBreed(String breed, int imagesNumber) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/images/random/${imagesNumber}");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// ALL IMAGES FROM A BREED COLLECTION
///
/// * `breed` breed name
///
/// Returns list of all the images from a breed, e.g. hound
Future<List<String>> imagesByBreed(String breed) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/images");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// SINGLE RANDOM IMAGE FROM A SUB BREED COLLECTION
///
/// * `breed` breed name
/// * `subBreed` sub_breed name
///
/// Returns a random dog image from a sub-breed, e.g. Afghan Hound
Future<String> randomImageBySubBreed(String breed, String subBreed) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/${subBreed.trim()}/images/random");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    return json["message"];
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// MULTIPLE IMAGES FROM A SUB-BREED COLLECTION
///
/// * `breed` breed name
/// * `subBreed` sub_breed name
/// * `imagesNumber` number of images
///
/// Return multiple random dog images from a sub-breed, e.g. Afghan Hound
Future<List<String>> multipleRandomImagesBySubBreed(String breed, String subBreed, int imagesNumber) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/${subBreed.trim()}/images/random/${imagesNumber}");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// LIST ALL SUB-BREED IMAGES
///
/// * `breed` breed name
/// * `subBreed` sub_breed name
///
/// Returns list of all the images from the sub-breed
Future<List<String>> imagesBySubBreed(String breed, String subBreed) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/${subBreed.trim()}/images");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// LIST ALL BREEDS
///
/// Returns map of all the breeds as keys and sub-breeds as values if it has
Future<Map<String, List<dynamic>>> breedsList() async {
  try {
    var response = await _getRequest("breeds/list/all");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    var map = Map<String, List<dynamic>>.from(json["message"]);
    return map;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}

/// LIST ALL SUB-BREEDS
///
/// * `breed` breed name
///
/// Returns list of all the sub-breeds from a breed if it has sub-breeds
Future<List<String>> subBreedsList(String breed) async {
  try {
    var response = await _getRequest("breed/${breed.trim()}/list");
    var json = jsonDecode(response);
    if (json["status"] != "success") {
      throw new DogAPIException(json["message"]);
    }
    List<String> list = [];
    for (var i in json["message"])
      list.add(i);
    if (list.isEmpty)
      throw new DogAPIException("the breed does not have sub-breeds");
    return list;
  } catch(ex) {
    throw new DogAPIException(ex.toString());
  }
}