import 'dart:convert';

import 'package:first_dart_project/produto.dart';
import 'package:http/http.dart' as http;

String getMessageForProduct(Produto product) {
  return 'Promoção de <b>${product.desconto}%</b>\n'
      '<b>Produto:</b> ${product.produto}\n'
      '<b>Valor normal:</b> ${product.vlrNormal}\n'
      '<b>Valor promoção:</b> ${product.vlrOferta}\n'
      '<b>Link: </b> https://www.kabum.com.br/produto/${product.codigo}';
}

Future<void> sendMessage(
    {required String message,
    required int chatId,
    required String botToken}) async {
  final response = await http.post(
      Uri.parse('https://api.telegram.org/bot$botToken/sendMessage'),
      body: jsonEncode(
          {'chat_id': chatId, 'text': message, 'parse_mode': 'html'}),
      headers: {'Content-type': 'application/json'});
  if (response.statusCode != 200) {
    throw Exception('Error trying to send message\n${response.body}');
  }
}
