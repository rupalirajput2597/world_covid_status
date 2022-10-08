import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:world_covid_status/core/core.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: ShimmerBox(height: 40),
        ),
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            children: (0.to(6)).map((i) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.2),
                highlightColor: Colors.white,
                child: Column(
                  children: [
                    if (i == 0 || i == 5)
                      Row(
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: 36,
                              height: 24),
                          Container(
                              margin: const EdgeInsets.all(8),
                              color: Colors.black,
                              width: 50,
                              height: 20),
                        ],
                      ),
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.black,
                            width: 36,
                            height: 24),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              color: Colors.black,
                              width: double.infinity,
                              height: 50),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
