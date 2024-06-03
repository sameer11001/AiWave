import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';
import '../core/values/consts.dart';

class NormalLogoWidget extends StatelessWidget {
  final double height;
  final double width;
  final double margin;
  const NormalLogoWidget({
    super.key,
    this.height = 150,
    this.width = 150,
    this.margin = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(margin),
          child: Image.asset(
            AppConstant.logo,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double height;
  final double width;
  final double margin;
  const LogoWidget({
    super.key,
    this.height = 150,
    this.width = 150,
    this.margin = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(margin),
          child: Image.asset(
            AppConstant.logo,
            height: height,
            width: width,
            fit: BoxFit.cover,
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class LogoWidgetWithLabel extends StatelessWidget {
  final String? label;
  final double height;
  final double width;
  final double padding;
  final double margin;
  const LogoWidgetWithLabel({
    super.key,
    this.label,
    this.height = 150,
    this.width = 150,
    this.padding = 8.0,
    this.margin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LogoWidget(
          height: height,
          width: width,
          margin: margin,
        ),
        const SizedBox(height: 15),
        Text(
          label ?? AppConstant.appName,
          textAlign: TextAlign.center,
          style: AppStyle.headLine1.copyWith(
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class AnimatedLogoWidgetWithLabel extends StatefulWidget {
  final String? label;
  final double height;
  final double width;
  final double padding;
  final double margin;

  const AnimatedLogoWidgetWithLabel({
    super.key,
    this.label,
    this.height = 150,
    this.width = 150,
    this.padding = 8.0,
    this.margin = 0,
  });

  @override
  State<AnimatedLogoWidgetWithLabel> createState() =>
      _AnimatedLogoWidgetWithLabelState();
}

class _AnimatedLogoWidgetWithLabelState
    extends State<AnimatedLogoWidgetWithLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust the duration as needed
    );

    // Create a Tween to animate the Offset
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0), // Start from left
      end: const Offset(0, 0), // End at the original position
    ).animate(_controller);

    // Create a Tween to animate the opacity
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0, // Fully opaque
    ).animate(_controller);

    // Start the animations
    _controller.forward();

    // Repeat the slide animation
    // _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: LogoWidget(
            height: widget.height,
            width: widget.width,
            margin: widget.margin,
          ),
        ),
        Container(
          height: widget.height * 0.5,
          width: 3,
          margin: EdgeInsets.symmetric(horizontal: widget.padding),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.label ?? AppConstant.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.headLine2.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    AppConstant.companyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.headLine2.copyWith(
                      color: context.theme.colorScheme.onBackground.withOpacity(
                        .7,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
