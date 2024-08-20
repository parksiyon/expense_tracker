import 'package:flutter/material.dart';
import 'package:flutter_vscode/add_expense.dart';
import 'package:flutter_vscode/chart/chart.dart';
import 'package:flutter_vscode/expenses_list.dart'; // Ensure this file exists
import 'package:flutter_vscode/models/expense.dart';
//import 'package:flutter_vscode/chart/chart_bar.dart';

class ExpenseTracker extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ExpenseTracker({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _registeredExpense = [
    Expense(
      category: Category.work,
      title: 'Flutter Course',
      amount: 50.0,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.leisure,
      title: 'Leisure Activity',
      amount: 25.0,
      date: DateTime.now(),
    ),
  ];

  void _addOn() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddExpense(
        onSubmitExpense: inputExpense,
      ),
    );
  }

  void inputExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void removeExpenses(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(
      () {
        _registeredExpense.remove(expense);
      },
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                _registeredExpense.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget onCenter = const Center(
      child: Text('Add expenses'),
    );
    if (_registeredExpense.isNotEmpty) {
      onCenter = ExpensesList(
        expenses: _registeredExpense,
        onRemove: removeExpenses,
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _addOn,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
        title: const Text(
          'Expense Tracker',
        ),
        centerTitle: true,
        backgroundColor: widget.isDarkMode
            ? Colors.black
            : Colors.blue, // AppBar background color
        foregroundColor: widget.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 245, 243, 243), // AppBar text color
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                    expenses: _registeredExpense), // Placeholder for the chart
                Expanded(
                  child: onCenter,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpense),
                ), // Placeholder for the chart
                Expanded(
                  child: onCenter,
                ),
              ],
            ),
    );
  }
}
