import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import '../attendance_screen.dart';
import '../bloc/attendance_cubit.dart';
import 'attendance_card.dart';
import 'attendance_edit_dialog.dart';

class AttendanceTab extends StatelessWidget {
  final String search;
  final DateTime todayKey;
  final DateTime today;

  const AttendanceTab({
    super.key,
    required this.search,
    required this.todayKey,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoaded) {
          final filtered = search.isEmpty
              ? state.attendances
              : state.attendances
                    .where(
                      (e) =>
                          e.name.toLowerCase().contains(search.toLowerCase()) ||
                          e.id.toLowerCase().contains(search.toLowerCase()),
                    )
                    .toList();

          if (filtered.isEmpty && search.isNotEmpty) {
            return _buildNoSearchResults(context);
          }

          if (filtered.isEmpty) {
            return _buildEmptyState(context);
          }

          return ResponsiveCardGrid(
            cardHeight: WidgetStyles.cardHeightSmall,
            children: filtered
                .map(
                  (emp) => AttendanceCard(
                    emp: emp,
                    todayKey: todayKey,
                    onEdit: () => _showEditDialog(context, emp),
                  ),
                )
                .toList(),
          );
        } else if (state is AttendanceError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'เกิดข้อผิดพลาด',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ไม่พบผลการค้นหา',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'ไม่พบข้อมูลการเข้างานที่ตรงกับคำค้นหา\nลองค้นหาด้วยชื่อหรือรหัสพนักงานอื่น',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.orange.shade50],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time,
              size: 80,
              color: Colors.orange.shade300,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'ยังไม่มีข้อมูลการเข้างาน',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'ยังไม่มีข้อมูลการเข้า-ออกงานของพนักงาน\nข้อมูลจะปรากฏเมื่อพนักงานเริ่มบันทึกเวลา',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, EmployeeAttendance emp) async {
    await showDialog(
      context: context,
      builder: (context) => AttendanceEditDialog(employee: emp, today: today),
    );
  }
}
