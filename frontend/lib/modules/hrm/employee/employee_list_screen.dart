import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/modules/hrm/employee/widgets/employee_dialog.dart';
import 'package:frontend/modules/hrm/employee/widgets/employee_search_bar.dart';
import 'package:frontend/modules/hrm/employee/widgets/employee_card.dart';
import 'services/employee_service.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late EmployeeService _service;
  List<Employee> employees = [];
  String _search = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _service = EmployeeService(
      baseUrl: 'http://localhost:3000',
    ); // ปรับ baseUrl ตามจริง
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() => _loading = true);
    try {
      employees = await _service.fetchEmployees();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
    setState(() => _loading = false);
  }

  List<Employee> get _filteredEmployees {
    if (_search.isEmpty) return employees;
    return employees
        .where(
          (e) =>
              e.firstName.contains(_search) ||
              e.lastName.contains(_search) ||
              e.employeeId.contains(_search),
        )
        .toList();
  }

  void _addOrEditEmployee({Employee? employee, int? index}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        employee: employee,
        onDelete: (employee != null && index != null)
            ? () async {
                await _deleteEmployee(employee);
              }
            : null,
      ),
    );
    if (result != null) {
      if (result is Employee) {
        if (index != null) {
          await _updateEmployee(result);
        }
      } else if (result is EmployeeWithPassword) {
        final empJson = result.employee.toJson();
        empJson['password'] = result.password;
        await _service.createEmployee(empJson);
      }
      await _fetchEmployees();
    }
  }

  Future<void> _createEmployee(Employee emp) async {
    try {
      await _service.createEmployee(emp.toJson());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เพิ่มพนักงานสำเร็จ')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เพิ่มพนักงานไม่สำเร็จ: $e')));
    }
  }

  Future<void> _updateEmployee(Employee emp) async {
    try {
      await _service.updateEmployee(emp.id, emp.toJson());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('แก้ไขข้อมูลไม่สำเร็จ: $e')));
    }
  }

  Future<void> _deleteEmployee(Employee emp) async {
    try {
      await _service.deleteEmployee(emp.id);
      await _fetchEmployees();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ลบพนักงานสำเร็จ')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ลบพนักงานไม่สำเร็จ: $e')));
    }
  }

  Widget _buildNoSearchResults() {
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
            'ไม่พบพนักงานที่ตรงกับ "$_search"\nลองค้นหาด้วยชื่อหรือรหัสพนักงานอื่น',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _search = '';
              });
              _fetchEmployees();
            },
            icon: const Icon(Icons.clear),
            label: const Text('ล้างการค้นหา'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade50],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'ยังไม่มีข้อมูลพนักงาน',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'เริ่มต้นโดยการเพิ่มข้อมูลพนักงานคนแรก\nเพื่อจัดการข้อมูลบุคลากรในระบบ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _addOrEditEmployee(),
            icon: const Icon(Icons.person_add),
            label: Text(l10n.addEmployee),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.employeeListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addEmployee,
            onPressed: () => _addOrEditEmployee(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EmployeeSearchBar(
              value: _search,
              onChanged: (v) => setState(() => _search = v),
              hintText: l10n.searchHint,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredEmployees.isEmpty && _search.isNotEmpty
                  ? _buildNoSearchResults()
                  : _filteredEmployees.isEmpty
                  ? _buildEmptyState()
                  : ResponsiveCardGrid(
                      cardHeight: WidgetStyles.cardHeightSmall,
                      children: _filteredEmployees
                          .map(
                            (emp) => EmployeeCard(
                              employee: emp,
                              onEdit: () => _addOrEditEmployee(
                                employee: emp,
                                index: employees.indexOf(emp),
                              ),
                              positionLabel: l10n.position,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
