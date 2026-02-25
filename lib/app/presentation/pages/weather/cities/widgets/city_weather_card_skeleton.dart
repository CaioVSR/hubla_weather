import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer skeleton placeholder matching the `CityWeatherCard` layout.
///
/// Displayed while initial weather data is being loaded.
class CityWeatherCardSkeleton extends StatelessWidget {
  const CityWeatherCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final shape = context.hublaShape;

    return Shimmer.fromColors(
      baseColor: colors.gray20,
      highlightColor: colors.gray10,
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(shape.largeIncreased),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon circle + name/condition + temperature
            Row(
              children: [
                _SkeletonBox(
                  height: 44,
                  width: 44,
                  borderRadius: shape.full,
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        height: 18,
                        width: 120,
                        borderRadius: shape.small,
                      ),
                      SizedBox(height: spacing.xxxs),
                      _SkeletonBox(
                        height: 14,
                        width: 80,
                        borderRadius: shape.small,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.xs),
                _SkeletonBox(
                  height: 28,
                  width: 60,
                  borderRadius: shape.small,
                ),
              ],
            ),
            SizedBox(height: spacing.sm),
            // Detail pill placeholders
            Row(
              children: [
                _SkeletonBox(
                  height: 22,
                  width: 80,
                  borderRadius: shape.full,
                ),
                SizedBox(width: spacing.xs),
                _SkeletonBox(
                  height: 22,
                  width: 55,
                  borderRadius: shape.full,
                ),
                SizedBox(width: spacing.xs),
                _SkeletonBox(
                  height: 22,
                  width: 75,
                  borderRadius: shape.full,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A rectangular shimmer placeholder with configurable dimensions.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: colors.gray20,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
