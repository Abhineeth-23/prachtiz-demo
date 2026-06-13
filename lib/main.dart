import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme imports
import 'theme/colors.dart';
import 'theme/styles.dart';

// Layout shell
import 'widgets/shell_layout.dart';

// Screens imports
import 'screens/overview/dashboard_screen.dart';
import 'screens/overview/analytics_screen.dart';
import 'screens/overview/patient_overview_screen.dart';
import 'screens/clinical/appointments_screen.dart';
import 'screens/clinical/health_records_screen.dart';
import 'screens/clinical/prescriptions_screen.dart';
import 'screens/clinical/lab_results_screen.dart';
import 'screens/clinical/vaccinations_screen.dart';
import 'screens/clinical/telemedicine_screen.dart';
import 'screens/clinical/consultation_screen.dart';
import 'screens/management/staff_screen.dart';
import 'screens/management/task_board_screen.dart';
import 'screens/management/vitals_monitor_screen.dart';
import 'screens/management/patients_list_screen.dart';
import 'screens/management/doctor_schedule_screen.dart';
import 'screens/admin/billing_screen.dart';
import 'screens/admin/invoices_screen.dart';
import 'screens/admin/services_screen.dart';
import 'screens/admin/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PraCHtiz Clinic Practice Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MainNavigationContainer(),
    );
  }
}

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  String _currentRoute = "/dashboard";

  Widget _getScreenForRoute(String route) {
    switch (route) {
      case "/dashboard":
        return DashboardScreen(onNavigate: _navigateTo);
      case "/analytics":
        return AnalyticsScreen();
      case "/patient-overview":
        return PatientOverviewScreen();
      case "/appointments":
        return AppointmentsScreen();
      case "/health-records":
        return HealthRecordsScreen();
      case "/prescriptions":
        return PrescriptionsScreen();
      case "/lab-results":
        return LabResultsScreen();
      case "/vaccinations":
        return VaccinationsScreen();
      case "/telemedicine":
        return TelemedicineScreen();
      case "/consultation":
        return ConsultationScreen();
      case "/staff":
        return StaffScreen();
      case "/kanban":
        return TaskBoardScreen();
      case "/vitals":
        return VitalsMonitorScreen();
      case "/patients":
        return PatientsListScreen(onNavigate: _navigateTo);
      case "/doctor-schedule":
        return DoctorScheduleScreen();
      case "/billing":
        return BillingScreen();
      case "/invoices":
        return InvoicesScreen();
      case "/services":
        return ServicesScreen();
      case "/settings":
        return SettingsScreen();
      default:
        return DashboardScreen(onNavigate: _navigateTo);
    }
  }

  String _getTitleForRoute(String route) {
    switch (route) {
      case "/dashboard":
        return "Clinical Dashboard";
      case "/analytics":
        return "Practice Performance Analytics";
      case "/patient-overview":
        return "Patient Case Overview";
      case "/appointments":
        return "Appointments Scheduler Queue";
      case "/health-records":
        return "EMR Health Records Archive";
      case "/prescriptions":
        return "Digital Rx Prescriptions Builder";
      case "/lab-results":
        return "Laboratory Diagnostic Reports";
      case "/vaccinations":
        return "Immunization Timeline & Logs";
      case "/telemedicine":
        return "Telehealth Secure Session Grid";
      case "/consultation":
        return "Active SOAP Consultation Notes";
      case "/staff":
        return "Practitioner & Nurse Directory";
      case "/kanban":
        return "Administrative Task Kanban Board";
      case "/vitals":
        return "ICU Live Vitals Telemetry";
      case "/patients":
        return "Registered Patient Directory";
      case "/doctor-schedule":
        return "Doctor Roster Availability Planner";
      case "/billing":
        return "POS Billing & Checkout Console";
      case "/invoices":
        return "Issued Invoices Ledger";
      case "/services":
        return "Services List Tariff Configuration";
      case "/settings":
        return "Clinic Profile System Settings";
      default:
        return "PraCHtiz Management System";
    }
  }

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShellLayout(
      activeRoute: _currentRoute,
      onNavigate: _navigateTo,
      pageTitle: _getTitleForRoute(_currentRoute),
      child: _getScreenForRoute(_currentRoute),
    );
  }
}
