import 'dart:convert';

class Produto {
  final String produto;
  final int codigo;
  final int desconto;
  final double vlrOferta;
  final double vlrNormal;

  Produto(
      {required this.produto,
      required this.codigo,
      required this.desconto,
      required this.vlrOferta,
      required this.vlrNormal});

  static Produto fromJson(Map<String, dynamic> json) {
    return Produto(
        produto: json['produto'],
        codigo: json['codigo'],
        desconto: json['desconto'],
        vlrOferta: json['vlr_oferta'],
        vlrNormal: double.parse(json['vlr_normal']));
  }

  Map<String, dynamic> toJson() {
    return {
      'produto': produto,
      'codigo': codigo,
      'desconto': desconto,
      'vlr_oferta': vlrOferta,
      'vlr_normal': vlrNormal.toString(),
    };
  }

  @override
  String toString() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJson());
  }
}
