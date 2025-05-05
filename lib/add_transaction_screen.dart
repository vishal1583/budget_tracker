import 'dart:convert';

import 'package:budget_tracker/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  SharedPreferences? prefObj;
  String ip = '';
  bool isLoading = false;
  String _transactionType = 'income';

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
    });
  }

  final _key = GlobalKey<FormState>();

  final _transactionTitle = TextEditingController();

  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 45),
                TextFormField(
                  decoration: InputDecoration(labelText: 'For What?'),
                  controller: _transactionTitle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid value';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid value';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 25),
                // Radio Button
                RadioListTile<String>(
                  title: Text('Income'),
                  value: 'income',
                  groupValue: _transactionType,
                  onChanged: (value) {
                    setState(() {
                      _transactionType = value!;
                    });
                  },
                ),
                const SizedBox(height: 3),
                RadioListTile<String>(
                  title: Text('Expense'),
                  value: 'expense',
                  groupValue: _transactionType,
                  onChanged: (value) {
                    setState(() {
                      _transactionType = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                addTransaction(context);
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTransaction(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    String url = 'http://$ip/budget_tracker/addTransaction.php';

    try {
      var response = await http.post(Uri.parse(url), body: {
        'title': _transactionTitle.text.trim(),
        'amount': _amountController.text.trim(),
        'type': _transactionType,
      });

      var jsonData = jsonDecode(response.body);
      var jsonString = jsonData['message'];

      if (jsonString == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Added Successfully')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
