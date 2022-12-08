import 'dart:convert';
import 'dart:io';

const configPath = 'config.json';

class Config {
  final String url;
  final int delayInMinutes;
  final int minimalDiscount;

  Config(
      {required this.url, this.delayInMinutes = 5, this.minimalDiscount = 60});

  static Config fromJson(Map<String, dynamic> value) {
    return Config(
        url: value['url'],
        delayInMinutes: value['delayInMinutes'],
        minimalDiscount: value['minimalDiscount']);
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
