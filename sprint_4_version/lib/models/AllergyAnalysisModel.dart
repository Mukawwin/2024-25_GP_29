class AllergyAnalysis {
  final Analysis analysis;
  final String extractedText;
  final bool success;
  final List<String> userAllergies;
  final Warnings warnings;

  AllergyAnalysis({
    required this.analysis,
    required this.extractedText,
    required this.success,
    required this.userAllergies,
    required this.warnings,
  });

  factory AllergyAnalysis.fromJson(Map<String, dynamic> json) {
    return AllergyAnalysis(
      analysis: Analysis.fromJson(json['analysis']),
      extractedText: json['extracted_text'],
      success: json['success'],
      userAllergies: List<String>.from(json['user_allergies']),
      warnings: Warnings.fromJson(json['warnings']),
    );
  }

  Map<String, dynamic> toJson() => {
        'analysis': analysis.toJson(),
        'extracted_text': extractedText,
        'success': success,
        'user_allergies': userAllergies,
        'warnings': warnings.toJson(),
      };
}

class Analysis {
  final List<String> analyzedTokens;
  final Map<String, dynamic> claudeMatches;
  final Map<String, dynamic> databaseMatches;
  final List<String> detectedAllergens;

  Analysis({
    required this.analyzedTokens,
    required this.claudeMatches,
    required this.databaseMatches,
    required this.detectedAllergens,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      analyzedTokens: List<String>.from(json['analyzed_tokens']),
      claudeMatches: Map<String, dynamic>.from(json['claude_matches']),
      databaseMatches: Map<String, dynamic>.from(json['database_matches']),
      detectedAllergens: List<String>.from(json['detected_allergens']),
    );
  }

  Map<String, dynamic> toJson() => {
        'analyzed_tokens': analyzedTokens,
        'claude_matches': claudeMatches,
        'database_matches': databaseMatches,
        'detected_allergens': detectedAllergens,
      };
}

class Warnings {
  final bool hasAllergens;
  final String message;
  final String severity;

  Warnings({
    required this.hasAllergens,
    required this.message,
    required this.severity,
  });

  factory Warnings.fromJson(Map<String, dynamic> json) {
    return Warnings(
      hasAllergens: json['has_allergens'],
      message: json['message'],
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'has_allergens': hasAllergens,
        'message': message,
        'severity': severity,
      };
}
