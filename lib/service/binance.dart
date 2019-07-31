import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import "package:hex/hex.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'binance_classes.dart';

const BASE = 'https://api.binance.com';

class BinanceApi {
  dynamic credentials;

  Future<dynamic> _public(String path, [Map<String, String> params]) async {
    String apiKey = credentials['apiKey'];
    final timestamp = new DateTime.now().millisecondsSinceEpoch;
    final signature = this.signature('timestamp=$timestamp');

    final uri = Uri.https('api.binance.com', '/api/$path', {
      'timestamp': timestamp.toString(),
      'signature': signature
    });
    final headers = {'X-MBX-APIKEY': apiKey};

    final response = await http.get(uri, headers: headers);

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {

      throw 'Error ' + response.statusCode.toString() + ' ' + response.body;
    }
  }

  void fetchCredentials() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File jsonFile = new File(directory.path + "/binance-credentials.json");

    if (jsonFile.existsSync()) {
      credentials = json.decode(jsonFile.readAsStringSync());
    }
  }

  void storeCredentials(String newCredentials) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File jsonFile = new File(directory.path + "/binance-credentials.json");

    credentials = newCredentials;

    if (!jsonFile.existsSync()) {
      jsonFile.createSync();
    }

    jsonFile.writeAsStringSync(credentials);
  }

  void deleteCredentials() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File jsonFile = new File(directory.path + "/binance-credentials.json");

    credentials = null;
    jsonFile.delete();
  }

  String signature(String query) {
    String secret = credentials['secretKey'];

    List<int> secretBytes = utf8.encode(secret);
    List<int> queryBytes = utf8.encode(query);

    Hmac hmacSha256 = new Hmac(sha256, secretBytes);
    Digest digest = hmacSha256.convert(queryBytes);

    String hash = HEX.encode(digest.bytes);

    return hash;
  }

  Future<AccountInfo> accountInfo() =>
    _public('/v3/account').then((r) => AccountInfo.fromMap(r));
}
