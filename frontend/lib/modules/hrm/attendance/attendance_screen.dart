import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'bloc/attendance_cubit.dart';
import 'widgets/attendance_card.dart';
import 'widgets/attendance_edit_dialog.dart';
import 'widgets/attendance_search_bar.dart';

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
  List<EmployeeAttendance> employees = [];
  DateTime today = DateTime.now();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    DateTime d(int minus) {
      final t = today.subtract(Duration(days: minus));
      return DateTime(t.year, t.month, t.day);
    }

    employees = [
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

    // หลังจากโหลด mock data ให้ load เข้า cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceCubit>().loadAttendances(employees);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayKey = DateTime(today.year, today.month, today.day);
    return BlocProvider(
      create: (_) => AttendanceCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(child: Text(l10n.attendanceTitle)),
              Text(
                _formatDate(today),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AttendanceSearchBar(
                value: _search,
                onChanged: (v) => setState(() => _search = v.trim()),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<AttendanceCubit, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoaded) {
                      final filtered = _search.isEmpty
                          ? state.attendances
                          : state.attendances
                                .where(
                                  (e) =>
                                      e.name.toLowerCase().contains(
                                        _search.toLowerCase(),
                                      ) ||
                                      e.id.toLowerCase().contains(
                                        _search.toLowerCase(),
                                      ),
                                )
                                .toList();
                      return ResponsiveCardGrid(
                        cardHeight: WidgetStyles.cardHeightSmall,
                        children: filtered
                            .map(
                              (emp) => GestureDetector(
                                onTap: () => _showEditDialog(emp),
                                child: AttendanceCard(
                                  emp: emp,
                                  todayKey: todayKey,
                                  onEdit: () => _showEditDialog(emp),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    } else if (state is AttendanceError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) => dt == null
      ? '-'
      : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _showEditDialog(EmployeeAttendance emp) async {
    await showDialog(
      context: context,
      builder: (context) => AttendanceEditDialog(employee: emp, today: today),
    );
  }
}
