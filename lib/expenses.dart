import 'package:design_training/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:design_training/models/expense.dart';
import 'package:design_training/widgets/expenses_list/expenses_list.dart';
import 'package:design_training/widgets/chart/chart.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key, required this.changeTheme});
  final void Function(bool onTumbler) changeTheme;
  @override
  State<Expenses> createState(){
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  bool brightnessFlag = false;
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'FlutterCourse',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work
    ),
    Expense(
        title: 'Cinema',
        amount: 15.49,
        date: DateTime.now(),
        category: Category.leisure
    ),
  ];
  void _changeBrightness(){
    brightnessFlag = !brightnessFlag;
    widget.changeTheme(brightnessFlag);
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('expense deleted'),
          action: SnackBarAction(
            label: 'come back!',
            onPressed: (){
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
          ),
        ),
    );
  }

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx)=>NewExpense(onAddExpanse: _addExpense));
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(child: Text('No expenses found'));
    if (_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense,);
    }
    return Scaffold(

      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [IconButton(
          onPressed: _changeBrightness,
          icon: const Icon(Icons.shield_moon),
        ),
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width<500?Column(
        children: [
          Chart(expenses:_registeredExpenses),
          Expanded(
              child: mainContent
          ),
        ],
      ):Row(
        children: [
          Expanded(
              child: Chart(expenses:_registeredExpenses)),
          Expanded(
              child: mainContent
          ),
        ],)
    );
  }
}