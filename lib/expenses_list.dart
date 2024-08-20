import 'package:flutter/material.dart';
import 'package:flutter_vscode/expense_items.dart';
import 'package:flutter_vscode/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemove});

  final List<Expense> expenses; // Use `Expense` for the list
  final void Function(Expense expense) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Allows ListView to fit inside Column
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Adjust the horizontal padding as needed
          child: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
          ),
        ),
        onDismissed: (direction) {
          onRemove(expenses[index]);
        },
        child: ExpenseItems(
          expenses[index],
        ),
      ),
    );
  }
}
