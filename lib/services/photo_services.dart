import 'dart:convert';

import 'package:awesome_app/models/photo_model.dart';
import 'package:http/http.dart' as http;

class PhotoServices {
  Future<List<PhotoModel>> fetchPhotoList(int page) async {
    try {
      var url = "https://api.pexels.com/v1/curated?page=$page&per_page=10";

      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            '563492ad6f91700001000001d31858f2979c43609e4c7d3b52ba5b9b',
      };

      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print(response.body);

      List photoData = jsonDecode(response.body)["photos"];
      List<PhotoModel> photoList = photoData
          .map<PhotoModel>((data) => PhotoModel.fromJson(data))
          .toList();
      return photoList;
    } catch (e) {
      throw e;
    }
  }
}
