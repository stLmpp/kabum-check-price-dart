import 'dart:convert';
import 'dart:io';

import 'package:first_dart_project/config.dart';
import 'package:first_dart_project/constants.dart' as constants;
import 'package:first_dart_project/kabum_response.dart';
import 'package:first_dart_project/produto.dart';
import 'package:first_dart_project/send_message.dart';
import 'package:http/http.dart' as http;

Future<List<Produto>> getProducts(Uri url) async {
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch');
  }
  final kabumResponse = json.decode(response.body);
  return KabumResponse.fromJson(kabumResponse).produtos;
}

Set<int> idsChecked = {};
int timesTried = 0;
int errorQuantity = 0;

Future<void> libMain() async {
  final config = await checkConfigFile();

  while (true) {
    timesTried++;
    print('\n-------------------\n\nExecuting for the $timesTried time');
    try {
      print('Getting products');
      final products = await getProducts(config.url);
      print('Found ${products.length} product(s)');
      for (final product in products) {
        print('Sending message for product ${product.codigo}');
        await sendMessage(
            message: getMessageForProduct(product),
            chatId: config.channelId,
            botToken: config.botToken);
        idsChecked.add(product.codigo);
        print('Waiting 5 seconds to send another message');
        sleep(Duration(seconds: 5));
      }
    } catch (error) {
      print('Error\n${error.toString()}');
      await sendMessage(
              message:
                  'Got error while checking Kabum prices\n<b>Error:</b> ${error.toString()}',
              chatId: config.myChatId,
              botToken: config.botToken)
          .catchError((_) {});

      if (errorQuantity >= constants.errorLimit) {
        await sendMessage(
            message:
                'Got more than ${constants.errorLimit} errors. Stopping the program.',
            chatId: config.channelId,
            botToken: config.botToken);
        break;
      } else {
        errorQuantity++;
      }
    }
    print('Waiting 5 minutes to try again');
    sleep(Duration(minutes: 5));
  }
}
