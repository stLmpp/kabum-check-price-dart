import 'dart:convert';
import 'dart:io';

import 'package:first_dart_project/config.dart';
import 'package:first_dart_project/kabum_response.dart';
import 'package:first_dart_project/produto.dart';
import 'package:http/http.dart' as http;

Future<List<Produto>> getProducts(String url) async {
  final response = await http.get(Uri.parse(url));
  final kabumResponse = json.decode(response.body);
  return KabumResponse.fromJson(kabumResponse).produtos;
}

int timesTried = 0;

Future<void> libMain() async {
  final config = await checkConfigFile();

  while (true) {
    timesTried++;
    print('Executing for the $timesTried time');
    print('Getting products');
    final produtos = await getProducts(config.url);
    print('Found ${produtos.length} product(s)');
    print('Waiting 5 minutes to try again');
    sleep(Duration(minutes: 5));
  }
}
