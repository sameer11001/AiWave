import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color borderColor;
  final IconData? icons;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadiusValue;
  final String? tooltip;
  final Color? disabledColor;
  const CustomButton({
    super.key,
    this.label,
    this.onPressed,
    this.icons,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadiusValue = 8.0,
    this.tooltip,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Tooltip(
        message: tooltip ?? '',
        child: MaterialButton(
          height: height ?? 50,
          minWidth: width ?? double.infinity,
          onPressed: onPressed,
          disabledTextColor: Colors.grey,
          disabledColor: disabledColor,
          disabledElevation: 2,
          color: backgroundColor ?? Get.theme.colorScheme.primary,
          padding: padding,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          child: icons == null
              ? Text(
                  label ?? '',
                  style: TextStyle(fontSize: 18, color: foregroundColor),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icons, color: foregroundColor),
                    if (label != null) const SizedBox(width: 8.0),
                    if (label != null)
                      Text(
                        label!,
                        style: TextStyle(fontSize: 18, color: foregroundColor),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomFutureButton extends StatefulWidget {
  const CustomFutureButton({
    super.key,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.height,
    this.width,
    this.padding,
    this.loadingColor,
  });

  final Future<void> Function()? onPressed;
  final Widget? label;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;

  @override
  State<CustomFutureButton> createState() => _CustomFutureButtonState();
}

class _CustomFutureButtonState extends State<CustomFutureButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: widget.padding ?? const EdgeInsets.all(14.0),
      color: widget.backgroundColor,
      minWidth: widget.width ?? double.infinity,
      height: widget.height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: widget.onPressed == null
          ? null
          : () async {
              setState(() => isLoading = true);
              try {
                await widget.onPressed?.call().whenComplete(() => null);
              } catch (_) {}
              setState(() => isLoading = false);
            },
      child: isLoading
          ? Center(
              child: LinearProgressIndicator(
                color: widget.loadingColor,
              ),
            )
          : widget.label,
    );
  }
}

class CustomLabelButton extends StatelessWidget {
  final String label;
  final IconData icons;
  final double borderRadiusValue;
  final void Function()? onPressed;
  final Color? backgroundColor;
  const CustomLabelButton({
    super.key,
    required this.label,
    required this.icons,
    this.borderRadiusValue = 25,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: backgroundColor ?? Get.theme.colorScheme.primary.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      elevation: 0.0,
      child: Row(
        children: [
          Icon(
            icons,
            size: 16,
          ),
          const SizedBox(width: 8.0),
          Text(label.tr),
        ],
      ),
    );
  }
}
