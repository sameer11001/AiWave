import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomChipWidget extends StatelessWidget {
  final String? assestImage;

  const CustomChipWidget({super.key, this.assestImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: .5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Get.theme.colorScheme.primary,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 15,
          child: ClipPath(
            clipper: WaveClipper(),
            child: assestImage != null
                ? Image.asset(
                    assestImage!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Get.theme.colorScheme.primary,
                  ),
          ),
        )
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstControlPoint = Offset(size.width / 5, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(
      size.width - (size.width / 3.24),
      size.height - 105,
    );

    var secondEndPoint = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}