import 'package:flutter/material.dart';
import 'package:flutter_vscode/models/expense.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, required this.onSubmitExpense});
  final void Function(Expense expense) onSubmitExpense;
  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final titleSave = TextEditingController();
  final amountSave = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(2020);
    final lastDate = DateTime(now.year, now.month, now.day + 7);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    //print(pickedDate);
    setState(
      () {
        _selectedDate = pickedDate;
      },
    );
  }

  @override
  void dispose() {
    titleSave.dispose();
    amountSave.dispose();
    super.dispose();
  }

  void submitData() {
    final enteredAmount = double.tryParse(
        amountSave.text); // tryParse('hello') => null, tryParse('1.12) => n1.12
    final amountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleSave.text.trim().isEmpty ||
        amountInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('invalid input'),
          content: const Text(' Please add valid title and amount'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('okay'))
          ],
        ),
      );
      return;
    }
    widget.onSubmitExpense(
      Expense(
        title: titleSave.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16, 48, 16, keyboard + 16),
          child: Column(
            children: [
              TextField(
                controller: titleSave,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountSave,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'no date selected'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            // ignore: non_constant_identifier_names
                            (Category) => DropdownMenuItem(
                              value: Category,
                              child: Text(
                                Category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        } else {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      }),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancel'),
                  ),
                  ElevatedButton(
                    onPressed: submitData,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 200, 162, 255)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text('Save Expense'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
