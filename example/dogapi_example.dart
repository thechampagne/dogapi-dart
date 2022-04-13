import 'package:dogapi/dogapi.dart';

void main() {
  multipleRandomImages(10).then((dogs) =>
      dogs.forEach((dog) => print(dog))
  );
}