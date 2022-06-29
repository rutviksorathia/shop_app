import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavvalue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https('flutter-update-8daac-default-rtdb.firebaseio.com',
        '/userFavorites/$userId/$id.json', {'auth': token});
    try {
      final responce = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (responce.statusCode >= 400) {
        _setFavvalue(oldStatus);
      }
    } catch (error) {
      _setFavvalue(oldStatus);
    }
  }
}
