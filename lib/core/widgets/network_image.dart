import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String? networkUrl;
  const MyNetworkImage({this.networkUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return networkUrl != null
        ? Image.network(
            networkUrl ?? "https://flagcdn.com/h40/in.png",
            height: 24,
            width: 36,
          )
        : const Icon(
            Icons.image,
            size: 28,
          );
  }
}
