
class FichaModel {
  final int id;
  final int visitId;
  final String pdfPath;

  FichaModel({
    required this.id,
    required this.visitId,
    required this.pdfPath,
  });

  factory FichaModel.fromJson(Map<String, dynamic> json) {
    return FichaModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      visitId: int.tryParse(json['id_visitas']?.toString() ?? '0') ?? 0,
      pdfPath: json['pdf_path'] as String? ?? '',
    );
  }
}
