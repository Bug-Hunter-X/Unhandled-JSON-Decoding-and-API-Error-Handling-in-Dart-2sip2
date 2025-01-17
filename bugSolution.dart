```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>?> fetchData() async {
  int retries = 3;
  while (retries > 0) {
    try {
      final response = await http.get(Uri.parse('https://api.example.com/data'));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          // Handle cases where the JSON structure may not be a list
          if (data is List) {
            return data;
          } else {
            print('Warning: API returned non-list JSON.');
            return [];
          }
        } on FormatException catch (e) {
          print('Error: Invalid JSON format: $e');
          retries--; // Decrement retries on JSON decoding errors
          await Future.delayed(Duration(seconds: 2));
          continue;
        }
      } else {
        print('Error fetching data: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      retries--;
      if (retries > 0) {
        print('Retry attempt failed. Retrying in 2 seconds. Retries remaining: $retries');
        await Future.delayed(Duration(seconds: 2));
        continue;
      } else {
        print('Error fetching data after multiple retries: $e');
        rethrow; // Re-throw the exception after all retries have failed
      }
    }
  }
  return null; //Return null if all retries have failed
}
```