import 'package:flutter/material.dart';
import 'package:design_training/models/expense.dart';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpanse});

  final void Function(Expense expense) onAddExpanse;
  @override
  State<NewExpense> createState(){
    return _NewExpenseState();
  }
}
class _NewExpenseState extends State<NewExpense>{
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async{
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1,now.month-1,now.day-1);
    final lastDate = DateTime(now.year+1,now.month+1,now.day+1);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please check entering in all positions'),
        actions: [
          TextButton(onPressed: (){Navigator.pop(ctx);}, child: const Text('LETS CHECK)'))
        ],
      ));
      return;
    }
    widget.onAddExpanse(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context){
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints){
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: 
              width <=500 ?Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 60,
                    decoration: const InputDecoration(
                        label: Text('Title')
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefix: Text('\$ '),
                              label: Text('Amount')
                          ),
                        ),
                      ),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null? 'No Selected Date': formatter.format(_selectedDate!),),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month)
                              )
                            ],
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map(
                                  (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase(),),)
                          ).toList(),
                          onChanged: (value){
                            if(value==null){
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: (){
                          _submitExpenseData();
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(180, 0, 255, 0)
                            )
                        ),
                        child: const Text('Save Expense', style: TextStyle(color: Colors.white),),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
                        child: const Text('Fuck, go back'),
                      )
                    ],),
                ],
              )
                  :Column(
                children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 60,
                            decoration: const InputDecoration(
                                label: Text('Title')
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefix: Text('\$ '),
                                label: Text('Amount')
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null? 'No Selected Date': formatter.format(_selectedDate!)),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month)
                              )
                            ],
                          )
                      ),
                      Expanded(
                        child: DropdownButton(
                            value: _selectedCategory,
                            items: Category.values.map(
                                    (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase(),),)
                            ).toList(),
                            onChanged: (value){
                              if(value==null){
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          _submitExpenseData();
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(180, 0, 255, 0)
                            )
                        ),
                        child: const Text('Save Expense', style: TextStyle(color: Colors.white),),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
                        child: const Text('Fuck, go back'),
                      )
                    ],),
                ],
              ),
          ),
        ),
      );
    });

  }
}