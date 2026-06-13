import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'topbar.dart';
import '../theme/colors.dart';

class ShellLayout extends StatefulWidget {
  final Widget child;
  final String activeRoute;
  final Function(String) onNavigate;
  final String pageTitle;

  ShellLayout({
    required this.child,
    required this.activeRoute,
    required this.onNavigate,
    required this.pageTitle,
  });

  @override
  State<ShellLayout> createState() => _ShellLayoutState();
}

class _ShellLayoutState extends State<ShellLayout> {
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? AppSidebar(
              activeRoute: widget.activeRoute,
              onNavigate: (route) {
                widget.onNavigate(route);
                _scaffoldKey.currentState?.closeDrawer();
              },
            )
          : null,
      body: Stack(
        children: [
          // Background Gradient (overlapping radial and linear gradients)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF4F7FB),
                    Color(0xFFEBF0F8),
                    Color(0xFFF0F5FA),
                  ],
                ),
              ),
            ),
          ),
          // Radial overlay 1
          Positioned(
            left: -100,
            top: 100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF273A91).withOpacity(0.045),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Radial overlay 2
          Positioned(
            right: -100,
            top: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF007A1F).withOpacity(0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Layout Content
          SafeArea(
            child: Row(
              children: [
                // Desktop Sidebar
                if (!isMobile)
                  AppSidebar(
                    activeRoute: widget.activeRoute,
                    onNavigate: widget.onNavigate,
                    isCollapsed: _isSidebarCollapsed,
                    onToggle: () {
                      setState(() {
                        _isSidebarCollapsed = !_isSidebarCollapsed;
                      });
                    },
                  ),

                // Main Content Block
                Expanded(
                  child: Column(
                    children: [
                      // Topbar header
                      AppTopbar(
                        pageTitle: widget.pageTitle,
                        onMenuPressed: () {
                          if (isMobile) {
                            _scaffoldKey.currentState?.openDrawer();
                          }
                        },
                      ),

                      // Swapped child view page
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
