class BannerModel {
  final String homeTitle;
  final String homeSubtitle;
  final String homeBanner;

  BannerModel({
    required this.homeTitle,
    required this.homeSubtitle,
    required this.homeBanner,

  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      homeTitle: json['home_title'],
      homeSubtitle: json['home_subtitle'],
      homeBanner: json['home_banner'],
    );
  }
}
