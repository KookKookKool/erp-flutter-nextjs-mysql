import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'bloc/attendance_cubit.dart';
import 'bloc/ot_cubit.dart';
import 'services/ot_data_service.dart';
import 'services/attendance_ot_integration_service.dart';
import 'widgets/attendance_search_bar.dart';
import 'widgets/attendance_tab.dart';
import 'widgets/ot_tab.dart';

class EmployeeAttendance {
  final String id;
  final String name;
  final Map<DateTime, Map<String, dynamic>>
  records; // key: date, value: {'in': DateTime?, 'out': DateTime?, 'otStart': DateTime?, 'otEnd': DateTime?, 'otRate': double}
  EmployeeAttendance({
    required this.id,
    required this.name,
    required this.records,
  });
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final DateTime today = DateTime.now();
  final AttendanceOtIntegrationService _otIntegrationService =
      AttendanceOtIntegrationService();

  List<EmployeeAttendance> _mockEmployees(DateTime today) {
    DateTime d(int minus) {
      final t = today.subtract(Duration(days: minus));
      return DateTime(t.year, t.month, t.day);
    }

    final employees = [
      EmployeeAttendance(
        id: 'EMP001',
        name: 'สมชาย ใจดี',
        records: {
          d(0): {
            'in': DateTime(today.year, today.month, today.day, 8, 30),
            'out': DateTime(today.year, today.month, today.day, 17, 0),
          },
          d(1): {
            'in': DateTime(d(1).year, d(1).month, d(1).day, 8, 40),
            'out': DateTime(d(1).year, d(1).month, d(1).day, 17, 5),
          },
          d(2): {'in': null, 'out': null},
          d(3): {
            'in': DateTime(d(3).year, d(3).month, d(3).day, 8, 35),
            'out': DateTime(d(3).year, d(3).month, d(3).day, 17, 2),
          },
          d(4): {
            'in': DateTime(d(4).year, d(4).month, d(4).day, 8, 50),
            'out': null,
          },
          d(5): {'in': null, 'out': null},
          d(6): {
            'in': DateTime(d(6).year, d(6).month, d(6).day, 8, 30),
            'out': DateTime(d(6).year, d(6).month, d(6).day, 17, 0),
          },
        },
      ),
      EmployeeAttendance(
        id: 'EMP002',
        name: 'สมหญิง ขยัน',
        records: {
          d(0): {'in': null, 'out': null},
          d(1): {
            'in': DateTime(d(1).year, d(1).month, d(1).day, 8, 45),
            'out': DateTime(d(1).year, d(1).month, d(1).day, 17, 10),
          },
          d(2): {'in': null, 'out': null},
          d(3): {'in': null, 'out': null},
          d(4): {'in': null, 'out': null},
          d(5): {'in': null, 'out': null},
          d(6): {'in': null, 'out': null},
        },
      ),
      EmployeeAttendance(
        id: 'EMP003',
        name: 'John Doe',
        records: {
          d(0): {
            'in': DateTime(today.year, today.month, today.day, 9, 0),
            'out': null,
          },
          d(1): {'in': null, 'out': null},
          d(2): {'in': null, 'out': null},
          d(3): {
            'in': DateTime(d(3).year, d(3).month, d(3).day, 8, 55),
            'out': DateTime(d(3).year, d(3).month, d(3).day, 17, 20),
          },
          d(4): {'in': null, 'out': null},
          d(5): {'in': null, 'out': null},
          d(6): {'in': null, 'out': null},
        },
      ),
    ];

    // Load approved OT data for all employees
    _loadApprovedOtData(employees);

    return employees;
  }

  Future<void> _loadApprovedOtData(List<EmployeeAttendance> employees) async {
    try {
      await _otIntegrationService.updateAllAttendanceWithApprovedOt(employees);
    } catch (e) {
      print('Error loading approved OT data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayKey = DateTime(today.year, today.month, today.day);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = AttendanceCubit();
            cubit.loadAttendances(_mockEmployees(today));
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = OtCubit(OtDataService());
            cubit.loadOtRequests();
            return cubit;
          },
        ),
      ],
      child: _AttendanceScreenView(
        today: today,
        todayKey: todayKey,
        l10n: l10n,
      ),
    );
  }
}

class _AttendanceScreenView extends StatefulWidget {
  final DateTime today;
  final DateTime todayKey;
  final AppLocalizations l10n;
  const _AttendanceScreenView({
    required this.today,
    required this.todayKey,
    required this.l10n,
  });
  @override
  State<_AttendanceScreenView> createState() => _AttendanceScreenViewState();
}

class _AttendanceScreenViewState extends State<_AttendanceScreenView>
    with TickerProviderStateMixin {
  String _search = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.l10n.attendanceTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AttendanceSearchBar(
              value: _search,
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
            const SizedBox(height: 16),
            // Tab Bar สำหรับสลับระหว่างบันทึกเวลาและ OT
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: SunTheme.sunOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: widget.l10n.attendanceModule,
                    icon: const Icon(Icons.access_time),
                  ),
                  Tab(text: 'OT', icon: const Icon(Icons.schedule)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAttendanceTab(), _buildOtTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab สำหรับแสดงรายการบันทึกเวลา
  Widget _buildAttendanceTab() {
    return AttendanceTab(
      search: _search,
      todayKey: widget.todayKey,
      today: widget.today,
    );
  }

  // Tab สำหรับแสดงรายการ OT
  Widget _buildOtTab() {
    return OtTab(search: _search);
  }
}
