import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/layouts/app_shell.dart';
import 'app_route_paths.dart';

// Screens
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/analytics/presentation/pages/analytics_screen.dart';
import '../../features/patients/presentation/pages/patient_overview_screen.dart';
import '../../features/patients/presentation/pages/patients_list_screen.dart';
import '../../features/appointments/presentation/pages/appointments_screen.dart';
import '../../features/health_records/presentation/pages/health_records_screen.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_screen.dart';
import '../../features/lab_results/presentation/pages/lab_results_screen.dart';
import '../../features/vaccinations/presentation/pages/vaccinations_screen.dart';
import '../../features/telemedicine/presentation/pages/telemedicine_screen.dart';
import '../../features/consultation/presentation/pages/consultation_screen.dart';
import '../../features/staff/presentation/pages/staff_screen.dart';
import '../../features/staff/presentation/pages/doctor_schedule_screen.dart';
import '../../features/tasks/presentation/pages/task_board_screen.dart';
import '../../features/vitals/presentation/pages/vitals_monitor_screen.dart';
import '../../features/billing/presentation/pages/billing_screen.dart';
import '../../features/invoices/presentation/pages/invoices_screen.dart';
import '../../features/services/presentation/pages/services_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

CustomTransitionPage<void> _transitionPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final offset = Tween<Offset>(
        begin: const Offset(0.018, 0),
        end: Offset.zero,
      ).animate(curved);

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: offset,
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutePaths.dashboard,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(
          activeRoute: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutePaths.dashboard,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: const DashboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.analytics,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: const AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.patientOverview,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: PatientOverviewScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.appointments,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: AppointmentsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.healthRecords,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: HealthRecordsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.prescriptions,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: PrescriptionsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.labResults,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: LabResultsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.vaccinations,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: VaccinationsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.telemedicine,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: TelemedicineScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.consultation,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: ConsultationScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.staff,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: StaffScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.doctorSchedule,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: DoctorScheduleScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.vitals,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: VitalsMonitorScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.patients,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: PatientsListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.tasks,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: TaskBoardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.billing,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: BillingScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.invoices,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: InvoicesScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.services,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: ServicesScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutePaths.settings,
          pageBuilder: (context, state) => _transitionPage(
            state: state,
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);
