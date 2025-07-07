import 'package:flutter/material.dart';

/// ResponsiveCardGrid: ใช้สำหรับแบ่ง column ตามขนาดหน้าจอ และกำหนดความสูง card ได้
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final double? cardHeight; // เพิ่ม parameter สำหรับความสูง card

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.padding,
    this.cardHeight,
  });

  int _getColumnCount(double width) {
    if (width >= 1601) return 4;
    if (width >= 1080) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _getColumnCount(constraints.maxWidth);
        return GridView.builder(
          //padding: padding ?? const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: cardHeight, // ใช้ความสูงที่กำหนด
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}
