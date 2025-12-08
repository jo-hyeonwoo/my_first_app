import 'dart:convert';

/// Utility functions for JSON parsing and cleaning
class JsonUtils {
  /// Cleans a JSON string by removing markdown code blocks and whitespace
  /// 
  /// LLMs sometimes wrap JSON responses in markdown code blocks like:
  /// ```json
  /// { ... }
  /// ```
  /// 
  /// Also handles cases where the response includes explanatory text before/after JSON
  /// 
  /// This function removes:
  /// - Leading/trailing whitespace
  /// - Markdown code block markers (```json, ```, etc.)
  /// - Text before/after JSON objects
  /// 
  /// Returns the cleaned JSON string ready for parsing
  static String cleanJsonString(String raw) {
    if (raw.isEmpty) return raw;

    // Remove leading and trailing whitespace
    String cleaned = raw.trim();

    // Remove markdown code block markers
    // Pattern: ```json ... ``` or ``` ... ```
    cleaned = cleaned.replaceAll(RegExp(r'^```json\s*', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^```\s*', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*```\s*$', multiLine: true), '');

    // Extract JSON object from text that may contain explanatory text
    // Look for the first { and last } to extract JSON object
    final jsonStart = cleaned.indexOf('{');
    final jsonEnd = cleaned.lastIndexOf('}');
    
    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      cleaned = cleaned.substring(jsonStart, jsonEnd + 1);
    }

    // Remove any remaining leading/trailing whitespace after cleaning
    cleaned = cleaned.trim();

    return cleaned;
  }

  /// Safely parses a JSON string, handling markdown code blocks
  /// 
  /// First cleans the string, then parses it as JSON.
  /// Throws [FormatException] if the string is not valid JSON.
  static dynamic parseJson(String jsonString) {
    final cleaned = cleanJsonString(jsonString);
    return jsonDecode(cleaned);
  }
}

