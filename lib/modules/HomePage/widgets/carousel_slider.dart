import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250,
        child: AnotherCarousel(
          images: const [
            ExactAssetImage("assets/slider1.png"),
            ExactAssetImage("assets/slider2.jpeg"),
          ],
          dotSize: 4.0,
          dotSpacing: 15.0,
          indicatorBgPadding: 5.0,
          autoplay: true,
          autoplayDuration: const Duration(seconds: 4),
        ),
      ),
    );
  }
}
