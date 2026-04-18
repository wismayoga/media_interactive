import '../core/api/api_service.dart';

class MateriModel {
  final int id;
  final String title;
  final String? type;
  final String? pdfUrl;

  final bool hasGroup;
  final bool joined;
  final int? groupId;
  final String? groupName;

  MateriModel({
    required this.id,
    required this.title,
    this.type,
    this.pdfUrl,
    required this.hasGroup,
    required this.joined,
    this.groupId,
    this.groupName,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      pdfUrl: json['pdf_url'] != null
          ? ApiService.baseDomain + json['pdf_url']
          : null,
      hasGroup: json['discussion']['has_group'] ?? false,
      joined: json['discussion']['joined'] ?? false,
      groupId: json['discussion']['group_id'],
      groupName: json['discussion']['group_name'],
    );
  }
}
