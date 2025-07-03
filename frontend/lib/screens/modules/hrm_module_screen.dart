import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/employee_service.dart';
import '../../bloc/employee_cubit.dart';

class HRMModuleScreen extends StatelessWidget {
  const HRMModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeCubit(
        EmployeeService(baseUrl: 'http://localhost:8000/backend/index.php'),
      )..fetchEmployees(),
      child: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeError) {
            return Center(child: Text('Error: \\${state.message}'));
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return const Center(child: Text('No employees found'));
            }
            return ListView.builder(
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final emp = state.employees[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(emp.username[0].toUpperCase()),
                  ),
                  title: Text(emp.username),
                  subtitle: Text(emp.email),
                  trailing: Text(emp.createdAt),
                );
              },
            );
          }
          return const Center(child: Text('HRM Module'));
        },
      ),
    );
  }
}
