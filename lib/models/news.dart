class News {
  final List<Cluster> clusters;

  const News({required this.clusters});

  factory News.fromJson(Map<String, dynamic> json) => News(
    clusters:
        (json['clusters'] as List<dynamic>)
            .map((e) => Cluster.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'clusters': clusters.map((c) => c.toJson()).toList(),
  };
}

class Cluster {
  final String? category;
  final String? emoji;
  final List<String>? timeline;
  final List<Perspective>? perspectives;
  final List<String>? talkingPoints;
  final String? humanitarianImpact;
  final List<String>? userActionItems;
  final List<Article>? articles;
  final String? shortSummary;
  final String title;
  final String? quote;
  final String? quoteAuthor;
  final String? quoteSourceUrl;
  final String? quoteSourceDomain;
  final String? location;
  final String? historicalBackground;
  final List<Domain>? domains;
  final String? didYouKnow;
  final List<String>? internationalReactions;
  final List<String>? industryImpact;
  final String? economicImplications;
  final List<String>? scientificSignificance;
  final dynamic technicalDetails;
  final List<String>? keyPlayers;
  final List<String>? businessAnglePoints;
  final String? userExperienceImpact;
  final List<String>? gameplayMechanics;
  final List<String>? diyTips;
  final List<String>? travelAdvisory;
  final List<String>? performanceStatistics;
  final int? numberOfTitles;
  final String? culinarySignificance;
  final String? designPrinciples;
  final String? destinationHighlights;
  final String? futureOutlook;

  const Cluster({
    this.category,
    this.emoji,
    this.timeline,
    this.perspectives,
    this.talkingPoints,
    this.humanitarianImpact,
    this.userActionItems,
    this.articles,
    this.shortSummary,
    required this.title,
    this.quote,
    this.quoteAuthor,
    this.quoteSourceUrl,
    this.quoteSourceDomain,
    this.location,
    this.historicalBackground,
    this.domains,
    this.didYouKnow,
    this.internationalReactions,
    this.industryImpact,
    this.economicImplications,
    this.scientificSignificance,
    this.technicalDetails,
    this.keyPlayers,
    this.businessAnglePoints,
    this.userExperienceImpact,
    this.gameplayMechanics,
    this.diyTips,
    this.travelAdvisory,
    this.performanceStatistics,
    this.numberOfTitles,
    this.culinarySignificance,
    this.designPrinciples,
    this.destinationHighlights,
    this.futureOutlook,
  });

  String get id =>
      quoteSourceUrl == null || quoteSourceUrl!.isEmpty
          ? title
          : quoteSourceUrl!;

  factory Cluster.fromJson(Map<String, dynamic> json) => Cluster(
    category: _parseStringValue(json['category']),
    emoji: _parseStringValue(json['emoji']),
    timeline: _parseStringOrList(json['timeline']),
    perspectives:
        (json['perspectives'] as List<dynamic>?)
            ?.map((e) => Perspective.fromJson(e as Map<String, dynamic>))
            .toList(),
    talkingPoints: _parseStringOrList(json['talking_points']),
    humanitarianImpact: _parseStringValue(json['humanitarian_impact']),
    userActionItems: _parseStringOrList(json['user_action_items']),
    articles:
        (json['articles'] as List<dynamic>?)
            ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
            .toList(),
    shortSummary: _parseStringValue(json['short_summary']),
    title: _parseStringValue(json['title']) ?? '',
    quote: _parseStringValue(json['quote']),
    quoteAuthor: _parseStringValue(json['quote_author']),
    quoteSourceUrl: _parseStringValue(json['quote_source_url']),
    quoteSourceDomain: _parseStringValue(json['quote_source_domain']),
    location: _parseStringValue(json['location']),
    historicalBackground: _parseStringValue(json['historical_background']),
    domains:
        (json['domains'] as List<dynamic>?)
            ?.map((e) => Domain.fromJson(e as Map<String, dynamic>))
            .toList(),
    didYouKnow: _parseStringValue(json['did_you_know']),
    internationalReactions: _parseStringOrList(json['international_reactions']),
    industryImpact: _parseStringOrList(json['industry_impact']),
    economicImplications: _parseStringValue(json['economic_implications']),
    scientificSignificance: _parseStringOrList(json['scientific_significance']),
    technicalDetails: json['technical_details'],
    keyPlayers: _parseStringOrList(json['key_players']),
    businessAnglePoints: _parseStringOrList(json['business_angle_points']),
    userExperienceImpact: _parseStringValue(json['user_experience_impact']),
    gameplayMechanics: _parseStringOrList(json['gameplay_mechanics']),
    diyTips: _parseStringOrList(json['diy_tips']),
    travelAdvisory: _parseStringOrList(json['travel_advisory']),
    performanceStatistics: _parseStringOrList(json['performance_statistics']),
    numberOfTitles:
        json['number_of_titles'] is int
            ? json['number_of_titles'] as int?
            : null,
    culinarySignificance: _parseStringValue(json['culinary_significance']),
    designPrinciples: _parseStringValue(json['design_principles']),
    destinationHighlights: _parseStringValue(json['destination_highlights']),
    futureOutlook: _parseStringValue(json['future_outlook']),
  );

  Map<String, dynamic> toJson() => {
    if (category != null) 'category': category,
    if (emoji != null) 'emoji': emoji,
    if (timeline != null) 'timeline': timeline,
    if (perspectives != null)
      'perspectives': perspectives!.map((p) => p.toJson()).toList(),
    if (talkingPoints != null) 'talking_points': talkingPoints,
    if (humanitarianImpact != null) 'humanitarian_impact': humanitarianImpact,
    if (userActionItems != null) 'user_action_items': userActionItems,
    if (articles != null) 'articles': articles!.map((a) => a.toJson()).toList(),
    if (shortSummary != null) 'short_summary': shortSummary,
    'title': title,
    if (quote != null) 'quote': quote,
    if (quoteAuthor != null) 'quote_author': quoteAuthor,
    if (quoteSourceUrl != null) 'quote_source_url': quoteSourceUrl,
    if (quoteSourceDomain != null) 'quote_source_domain': quoteSourceDomain,
    if (location != null) 'location': location,
    if (historicalBackground != null)
      'historical_background': historicalBackground,
    if (domains != null) 'domains': domains!.map((d) => d.toJson()).toList(),
    if (didYouKnow != null) 'did_you_know': didYouKnow,
    if (internationalReactions != null)
      'international_reactions': internationalReactions,
    if (industryImpact != null) 'industry_impact': industryImpact,
    if (economicImplications != null)
      'economic_implications': economicImplications,
    if (scientificSignificance != null)
      'scientific_significance': scientificSignificance,
    if (technicalDetails != null) 'technical_details': technicalDetails,
    if (keyPlayers != null) 'key_players': keyPlayers,
    if (businessAnglePoints != null)
      'business_angle_points': businessAnglePoints,
    if (userExperienceImpact != null)
      'user_experience_impact': userExperienceImpact,
    if (gameplayMechanics != null) 'gameplay_mechanics': gameplayMechanics,
    if (diyTips != null) 'diy_tips': diyTips,
    if (travelAdvisory != null) 'travel_advisory': travelAdvisory,
    if (performanceStatistics != null)
      'performance_statistics': performanceStatistics,
    if (numberOfTitles != null) 'number_of_titles': numberOfTitles,
    if (culinarySignificance != null)
      'culinary_significance': culinarySignificance,
    if (designPrinciples != null) 'design_principles': designPrinciples,
    if (destinationHighlights != null)
      'destination_highlights': destinationHighlights,
    if (futureOutlook != null) 'future_outlook': futureOutlook,
  };
}

class Perspective {
  final List<Domain>? sources;
  final String? text;

  const Perspective({this.sources, this.text});

  factory Perspective.fromJson(Map<String, dynamic> json) => Perspective(
    sources:
        (json['sources'] as List<dynamic>?)
            ?.map((e) => Domain.fromJson(e as Map<String, dynamic>))
            .toList(),
    text: _parseStringValue(json['text']),
  );

  Map<String, dynamic> toJson() => {
    if (sources != null) 'sources': sources,
    if (text != null) 'text': text,
  };
}

class Article {
  final String? date;
  final String? title;
  final String? domain;
  final String? link;
  final String? image;
  final String? imageCaption;

  const Article({
    this.date,
    this.title,
    this.domain,
    this.link,
    this.image,
    this.imageCaption,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    date: _parseStringValue(json['date']),
    title: _parseStringValue(json['title']),
    domain: _parseStringValue(json['domain']),
    link: _parseStringValue(json['link']),
    image: _parseStringValue(json['image']),
    imageCaption: _parseStringValue(json['image_caption']),
  );

  Map<String, dynamic> toJson() => {
    if (date != null) 'date': date,
    if (title != null) 'title': title,
    if (domain != null) 'domain': domain,
    if (link != null) 'link': link,
    if (image != null) 'image': image,
    if (imageCaption != null) 'image_caption': imageCaption,
  };
}

class Domain {
  final String? name;
  final String? url;

  const Domain({this.name, this.url});

  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
    name: _parseStringValue(json['name']),
    url: _parseStringValue(json['favicon']) ?? _parseStringValue(json['url']),
  );

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (url != null) 'url': url,
  };
}

class NewsResponse {
  final int timestamp;
  final News news;

  const NewsResponse({required this.timestamp, required this.news});

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    timestamp:
        json['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    news: News.fromJson(json),
  );

  Map<String, dynamic> toJson() => {'timestamp': timestamp, ...news.toJson()};
}

List<String> _parseStringOrList(dynamic value) {
  if (value == null) return [];
  if (value is String) return [value];
  if (value is List) return value.map((e) => e.toString()).toList();
  return [];
}

String? _parseStringValue(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}
