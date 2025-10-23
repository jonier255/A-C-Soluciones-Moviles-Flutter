
class FichaModel {
  final int id;
  final int visitId;
  final int tecnicoId;
  final String pdfPath;

  FichaModel({
    required this.id,
    required this.visitId,
    required this.tecnicoId,
    required this.pdfPath,
  });

  factory FichaModel.fromJson(Map<String, dynamic> json) {
    String pdfPath = json['pdf_path'] as String? ?? '';
    if (pdfPath.startsWith('uploads/')) {
      pdfPath = pdfPath.replaceFirst('uploads/', '');
    }
    return FichaModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      visitId: int.tryParse(json['id_visitas']?.toString() ?? '0') ?? 0,
      tecnicoId: int.tryParse(json['id_tecnico']?.toString() ?? '0') ?? 0,
      pdfPath: pdfPath,
    );
  }
}
