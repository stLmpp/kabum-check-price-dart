import 'dart:convert';
import 'dart:io';

const configPath = 'config.json';
const requiredFields = ['url', 'channelId', 'myChatId', 'botToken'];

class Config {
  late final Uri url;
  late final int delayInMinutes;
  late final int channelId;
  late final int myChatId;
  late final String botToken;
  late final String campaign;

  Config.fromJson(Map<String, dynamic> json) {
    for (final requiredField in requiredFields) {
      if (json[requiredField] == null) {
        throw Exception('$requiredField is required in the config.json');
      }
    }
    final int minimalDiscount = json['minimalDiscount'] ?? 60;
    final url = Uri.parse(json['url']);
    this.url = Uri.https(url.host, url.path, {
      ...url.queryParameters,
      'desconto_minimo': minimalDiscount.toString()
    });
    delayInMinutes = json['delayInMinutes'] ?? 5;
    channelId = json['channelId'];
    myChatId = json['myChatId'];
    botToken = json['botToken'];
    campaign = url.queryParameters['campanha'] ?? 'unknown';
  }
}

Future<Config> checkConfigFile() async {
  final file = File(configPath);
  final exists = await file.exists();
  if (exists) {
    final fileAsString = await file.readAsString();
    final fileAsJson = json.decode(fileAsString);
    return Config.fromJson(fileAsJson);
  }
  throw Exception(
      'config.json not found, use the config.example.json to create one');
}
