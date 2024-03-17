// ignore_for_file: avoid_print, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'app_exceptions.dart';

// ignore: non_constant_identifier_names
String MESSAGE_KEY = 'message';

class ResponseHandler {
  Map<String, String> setTokenHeader() {
    return {
      '': ''
    }; //{'Authorization': 'Bearer ${Constants.authenticatedToken}'};
  }

  Future post(
      Uri url, Map<String, dynamic> params,) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.post(url, body: params, headers: head).timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= true) throw FetchDataException(responseJson['msg'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future postWithJsonRequest(
      Uri url, dynamic params,) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    var params1 = utf8.encode(json.encode(params));
    try {
      final response = await http.post(url, body: params1, headers: head).timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= true) throw FetchDataException(responseJson['msg'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Future stripePost(
  //     Uri url, dynamic body,String publishableKey) async {
  //   var head = <String, String>{};
  //
  //   head['Authorization'] = 'Bearer $publishableKey';
  //   head['content-type'] = 'application/x-www-form-urlencoded';
  //   // ignore: prefer_typing_uninitialized_variables
  //   var responseJson;
  //   try {
  //     final response = await http.post(url, body: body, headers: head).timeout(const Duration(seconds: 45));
  //     responseJson = response.body;
  //     // ignore: avoid_print
  //     print(responseJson);
  //     if(response.statusCode!= 200) throw FetchDataException(responseJson);
  //     return responseJson;
  //   } on TimeoutException {
  //     throw FetchDataException("Slow internet connection");
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  // }

  Future postImage(String url, Map<String, String> params,
      XFile image) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    var res;
    var jsonData;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      final file = await http.MultipartFile.fromPath(
          'sign_board_image',
          image
              .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
      request.files.add(file);
          request.fields.addAll(params);
      await request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
        res = response.stream;
      });
      await for(List<int> chunk in res) {
        final chunkString = utf8.decode(chunk);
         jsonData = json.decode(chunkString);
        print('Received JSON data: $jsonData');
      }
      // if(res['status']!= true) throw FetchDataException(res['msg'].toString());
      return jsonData;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future postImageForOptions(String url, XFile image) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    var res;
    var jsonData;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      final file = await http.MultipartFile.fromPath(
          'image',
          image
              .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
      request.files.add(file);
          await request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
        res = response.stream;
      });
      await for(List<int> chunk in res) {
        final chunkString = utf8.decode(chunk);
        jsonData = json.decode(chunkString);
        print('Received JSON data: $jsonData');
      }
      // if(res['status']!= true) throw FetchDataException(res['msg'].toString());
      return jsonData;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future get(Uri url) async {
    var head = <String, String>{};
    head['content-type'] = 'application/json; charset=utf-8';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {

      final response = await http.get(url, headers: head).timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= true) throw FetchDataException(responseJson['msg'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

}
