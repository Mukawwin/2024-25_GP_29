class OcrResponse {
  final Analysis analysis;
  final String extractedText;
  final bool success;

  OcrResponse({
    required this.analysis,
    required this.extractedText,
    required this.success,
  });

  factory OcrResponse.fromJson(Map<String, dynamic> json) {
    return OcrResponse(
      analysis: Analysis.fromJson(json['analysis']),
      extractedText: json['extracted_text'] as String,
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysis': analysis.toJson(),
      'extracted_text': extractedText,
      'success': success,
    };
  }
}

class Analysis {
  final Map<String, dynamic> allergenDetails;
  final Map<String, dynamic> allergenLocations;
  final List<dynamic> foundAllergens;
  final bool hasAllergens;
  final String severity;
  final String warning;

  Analysis({
    required this.allergenDetails,
    required this.allergenLocations,
    required this.foundAllergens,
    required this.hasAllergens,
    required this.severity,
    required this.warning,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      allergenDetails: json['allergen_details'] as Map<String, dynamic>,
      allergenLocations: json['allergen_locations'] as Map<String, dynamic>,
      foundAllergens: json['found_allergens'] as List<dynamic>,
      hasAllergens: json['has_allergens'] as bool,
      severity: json['severity'] as String,
      warning: json['warning'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allergen_details': allergenDetails,
      'allergen_locations': allergenLocations,
      'found_allergens': foundAllergens,
      'has_allergens': hasAllergens,
      'severity': severity,
      'warning': warning,
    };
  }
}
