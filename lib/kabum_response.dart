import 'package:first_dart_project/produto.dart';

class KabumResponse {
  final List<Produto> produtos;

  KabumResponse({required this.produtos});

  static KabumResponse fromJson(Map<String, dynamic> json) {
    final List<dynamic> produtosJson = json['produtos'];
    final produtos =
        produtosJson.map((produto) => Produto.fromJson(produto)).toList();
    return KabumResponse(produtos: produtos);
  }

  Map<String, dynamic> toJson() {
    return {'produtos': produtos.map((v) => v.toJson()).toList()};
  }
}
