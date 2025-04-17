import 'package:kite/models/category.dart';

/// Extension on [Category] to get the emoji representation of the category.
extension CategoryEmoji on Category {
  String get emoji => _categoryEmojiMap[name] ?? '📰';
}

// Mapping of category names to their corresponding emoji representations.
const Map<String, String> _categoryEmojiMap = {
  'World': '🌍',
  'USA': '🇺🇸',
  'Business': '💼',
  'Technology': '🖥️',
  'Science': '🔬',
  'Sports': '🏀',
  'Gaming': '🎮',
  'Bay Area': '🌉',
  'Linux & OSS': '🐧',
  'Cryptocurrency': '₿',
  'Europe': '🇪🇺',
  'UK': '🇬🇧',
  'Ukraine': '🇺🇦',
  'Brazil': '🇧🇷',
  'Australia': '🇦🇺',
  'Estonia': '🇪🇪',
  'Mexico': '🇲🇽',
  'Germany': '🇩🇪',
  'Germany | Hesse': '🇩🇪',
  'Italy': '🇮🇹',
  'Canada': '🇨🇦',
  'Thailand': '🇹🇭',
  'Serbia': '🇷🇸',
  'USA | Vermont': '🇺🇸',
  'Japan': '🇯🇵',
  'Israel': '🇮🇱',
  'New Zealand': '🇳🇿',
  'Portugal': '🇵🇹',
  'France': '🇫🇷',
  'Poland': '🇵🇱',
  'Slovenia': '🇸🇮',
  'Spain': '🇪🇸',
  'Ireland': '🇮🇪',
  'Belgium': '🇧🇪',
  'The Netherlands': '🇳🇱',
  'Romania': '🇷🇴',
  'OnThisDay': '📅',
};
