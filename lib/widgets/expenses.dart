import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_2040/widgets/chart/chart.dart';
import 'package:flutter_expense_tracker_2040/widgets/expenses_list/expenses_list.dart';
import 'package:flutter_expense_tracker_2040/models/expense.dart';
import 'package:flutter_expense_tracker_2040/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _reqisteredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 799,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'PVR Cinema',
      amount: 480,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // so that the camera icon doesn't overlap the content we wrote
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _reqisteredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _reqisteredExpenses.indexOf(expense);
    setState(() {
      _reqisteredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: 3),
          content: const Text('Expense deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _reqisteredExpenses.insert(expenseIndex, expense);
              });
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    // ToDo: implement build

    if (_reqisteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _reqisteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _reqisteredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _reqisteredExpenses),
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
