// Base URL for Kite API
const String baseUrl = 'https://kite.kagi.com';

// Endpoints for the Kite API
const String categoriesUrl = '$baseUrl/kite.json';
const String onThisDayUrl = '$baseUrl/onthisday.json';

// Helper to build a news URL for a given category file
String newsEndpoint(String categoryFile) => '$baseUrl/$categoryFile';
