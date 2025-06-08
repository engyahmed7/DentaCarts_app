class HomeSettings {
  String homeTitle;
  String homeSubtitle;
  String? homeBanner;

  HomeSettings(
      {required this.homeTitle, required this.homeSubtitle, this.homeBanner});

  factory HomeSettings.fromJson(Map<String, dynamic> json) {
    return HomeSettings(
      homeTitle: json['home_title'],
      homeSubtitle: json['home_subtitle'],
      homeBanner: json['home_banner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home_title': homeTitle,
      'home_subtitle': homeSubtitle,
      'home_banner': homeBanner,
    };
  }
}
