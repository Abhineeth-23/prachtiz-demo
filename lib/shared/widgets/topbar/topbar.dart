import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/navigation/app_route_paths.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_assets.dart';
import '../../icons/app_icons.dart';
import '../app_searchbar.dart';
import 'live_pulse_badge.dart';
import 'availability_dropdown.dart';
import 'notification_button.dart';
import 'profile_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared brand constants
// ─────────────────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF24C06F);
const _kSlate = Color(0xFF94A3B8);
const _kDivider = Color(0xFF1E293B);
const _kHeaderBg = Color(0xFF13294B);

class AppTopbar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final String pageTitle;

  /// Whether the sidebar is currently collapsed.
  /// Used to animate the logo panel width in sync with the sidebar.
  final bool isCollapsed;

  /// Called when the user taps the logo area to toggle sidebar.
  final VoidCallback? onLogoAreaTap;

  const AppTopbar({
    super.key,
    this.onMenuPressed,
    required this.pageTitle,
    this.isCollapsed = false,
    this.onLogoAreaTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth < 1100 && !isMobile;

    return FocusTraversalGroup(
      child: Container(
        height: AppDimensions.topbarHeight,
        decoration: const BoxDecoration(
          color: _kHeaderBg,
          border: Border(
            bottom: BorderSide(
              color: _kDivider,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left: Unified Logo Panel ────────────────────────────────────
            if (!isMobile)
              _LogoPanel(
                isCollapsed: isCollapsed,
                onTap: onLogoAreaTap,
              ),

            // ── Mobile: Hamburger + Logo ────────────────────────────────────
            if (isMobile) ...[
              IconButton(
                icon: const Icon(AppIcons.menu, color: _kSlate),
                onPressed: onMenuPressed,
                tooltip: 'Open menu drawer',
              ),
              const SizedBox(width: 8),
              _InlineMobileLogo(),
            ],

            // ── Right: Topbar actions ────────────────────────────────────────
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isMobile ? 14.0 : 24.0),
                child: isMobile
                    ? _MobileActions()
                    : isTablet
                        ? _TabletActions()
                        : _DesktopActions(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo Panel — left section of the topbar, merges with the sidebar visually
// ─────────────────────────────────────────────────────────────────────────────
class _LogoPanel extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback? onTap;

  const _LogoPanel({required this.isCollapsed, this.onTap});

  @override
  Widget build(BuildContext context) {
    final double panelWidth = isCollapsed
        ? AppDimensions.sidebarCollapsedWidth
        : AppDimensions.sidebarWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: panelWidth,
      decoration: BoxDecoration(
        color: _kHeaderBg,
        border: const Border(
          right: BorderSide(color: _kDivider, width: 1.0),
        ),
      ),
      child: MouseRegion(
        cursor:
            onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 10 : 18,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale:
                      Tween<double>(begin: 0.94, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: isCollapsed
                  ? const _CollapsedLogo(key: ValueKey('collapsed'))
                  : const _ExpandedLogo(key: ValueKey('expanded')),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Expanded: full PraCHtiz logo ─────────────────────────────────────────────
class _ExpandedLogo extends StatelessWidget {
  const _ExpandedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Image.asset(
          AppAssets.logoClinical,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const _PraCHtizText(),
        ),
      ),
    );
  }
}

// ── Collapsed: dedicated CallHealth logo ────────────────────────────────────
class _CollapsedLogo extends StatelessWidget {
  const _CollapsedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          AppAssets.logoCallHealth,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _kGreen.withOpacity(0.12),
              border: Border.all(color: _kGreen.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              'CH',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Text fallback when image fails to load ────────────────────────────────────
class _PraCHtizText extends StatelessWidget {
  const _PraCHtizText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Pra',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0)),
            Text('CH',
                style: GoogleFonts.poppins(
                    color: _kGreen,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0)),
            Text('tiz',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0)),
          ],
        ),
        Text(
          'A Product by CallHealth',
          style: GoogleFonts.inter(
            color: _kSlate,
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

// ── Mobile inline logo (shown after hamburger on mobile) ──────────────────────
class _InlineMobileLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoClinical,
      width: 118,
      height: 40,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text('Pra',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0)),
          Text('CH',
              style: GoogleFonts.poppins(
                  color: _kGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0)),
          Text('tiz',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action areas (Desktop / Tablet / Mobile)
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopActions extends StatelessWidget {
  const _DesktopActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppSearchBar(width: 420, height: 40),
        const Spacer(),
        const _PresencePill(),
        const SizedBox(width: 16),
        const LivePulseBadge(activeCases: 8),
        const SizedBox(width: 16),
        const AvailabilityDropdown(),
        const SizedBox(width: 16),
        NotificationButton(
          icon: Icons.notifications_none_outlined,
          badgeCount: 5,
          badgeColor: const Color(0xFF24C06F),
          tooltip: 'View alerts',
          onPressed: () => context.go(AppRoutePaths.appointments),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: _kSlate),
          onPressed: () => context.go(AppRoutePaths.settings),
          tooltip: 'Settings',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8.0),
        ),
        const SizedBox(width: 16),
        ProfileWidget(
          initials: 'AB',
          name: 'Dr. Amanulla Beig',
          role: 'General Physician',
          onTap: () => context.go(AppRoutePaths.settings),
        ),
      ],
    );
  }
}

class _TabletActions extends StatelessWidget {
  const _TabletActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppSearchBar(width: 320, height: 40),
          ),
        ),
        const SizedBox(width: 12),
        NotificationButton(
          icon: Icons.notifications_none_outlined,
          badgeCount: 5,
          badgeColor: const Color(0xFF24C06F),
          tooltip: 'View alerts',
          onPressed: () => context.go(AppRoutePaths.appointments),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: _kSlate, size: 20),
          onPressed: () => context.go(AppRoutePaths.settings),
          tooltip: 'Settings',
        ),
        const SizedBox(width: 16),
        ProfileWidget(
          initials: 'AB',
          name: 'Dr. Amanulla Beig',
          role: 'General Physician',
          onTap: () => context.go(AppRoutePaths.settings),
        ),
      ],
    );
  }
}

class _MobileActions extends StatelessWidget {
  const _MobileActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.search, color: _kSlate, size: 20),
          onPressed: () => _showMobileSearch(context),
          tooltip: 'Search',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8.0),
        ),
        const SizedBox(width: 8),
        ProfileWidget(
          initials: 'AB',
          name: 'Dr. Amanulla Beig',
          role: 'General Physician',
          onTap: () => context.go(AppRoutePaths.settings),
        ),
      ],
    );
  }

  void _showMobileSearch(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF13294B),
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: AppSearchBar(width: double.infinity, height: 44),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Presence Pill — "who's in now"
// ─────────────────────────────────────────────────────────────────────────────
class _PresencePill extends StatelessWidget {
  const _PresencePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF13294B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(
            'Maria Santos',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'in now',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
