import 'package:flutter/material.dart';

import '/../../core/core.dart';

class CovidDetailScreenShimmer extends StatelessWidget {
  const CovidDetailScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            28.0, (MediaQuery.of(context).size.height * 0.01 + 28), 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(height: 10, width: 50),
                    SizedBox(height: 8),
                    ShimmerBox(height: 10, width: 100),
                    SizedBox(height: 8),
                    ShimmerBox(height: 10, width: 120),
                    SizedBox(height: 20),
                    ShimmerBox(height: 50, width: 120),
                  ],
                ),
                const ShimmerBox(height: 25, width: 40),
              ],
            ),
            const SizedBox(height: 20),
            const ShimmerBox(height: 120),
            const SizedBox(height: 30),
            const ShimmerBox(height: 80),
            const SizedBox(height: 30),
            const ShimmerBox(height: 80),
          ],
        ),
      ),
    );
  }
}
