import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ResponsiveTestWidget extends StatelessWidget {
  const ResponsiveTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Test'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context, 'Screen Size', _getScreenInfo(context)),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Responsive Values',
              _getResponsiveInfo(context),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(context, 'Breakpoints', _getBreakpointInfo(context)),
            const SizedBox(height: 16),
            _buildResponsiveGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 18.0,
                  tablet: 20.0,
                  desktop: 22.0,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 14.0,
                  tablet: 16.0,
                  desktop: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScreenInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return '''
Width: ${size.width.toStringAsFixed(0)}px
Height: ${size.height.toStringAsFixed(0)}px
Orientation: ${orientation.name}
Pixel Density: ${MediaQuery.of(context).devicePixelRatio.toStringAsFixed(2)}x
''';
  }

  String _getResponsiveInfo(BuildContext context) {
    return '''
Font Size: ${ResponsiveUtils.getResponsiveFontSize(context)}px
Padding: ${ResponsiveUtils.getResponsivePadding(context)}px
Grid Columns: ${ResponsiveUtils.getGridCrossAxisCount(context)}
''';
  }

  String _getBreakpointInfo(BuildContext context) {
    return '''
Mobile (< 600px): ${ResponsiveUtils.isMobile(context)}
Tablet (600-1024px): ${ResponsiveUtils.isTablet(context)}
Desktop (> 1024px): ${ResponsiveUtils.isDesktop(context)}
Landscape: ${ResponsiveUtils.isLandscape(context)}
''';
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Grid ($crossAxisCount columns)',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 18.0,
                  tablet: 20.0,
                  desktop: 22.0,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.0 : 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${index + 1}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          mobile: 12.0,
                          tablet: 14.0,
                          desktop: 16.0,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
