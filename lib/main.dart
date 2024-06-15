import 'package:flutter/material.dart';

void main() {
  runApp(AgeCalculatorApp());
}

class AgeCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgeCalculator(),
    );
  }
}

class AgeCalculator extends StatefulWidget {
  @override
  _AgeCalculatorState createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends State<AgeCalculator> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  int? _age;
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Update the TextField value
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      setState(() {
        _age = calculateAge(_selectedDate!, DateTime.now());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date.'),
        ),
      );
    }
  }

  int calculateAge(DateTime birthDate, DateTime currentDate) {
    int age = currentDate.year - birthDate.year;
    int monthDiff = currentDate.month - birthDate.month;
    int dayDiff = currentDate.day - birthDate.day;

    if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Age Calculator',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.lightGreen,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your birthdate:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true, // Make the TextField read-only
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Birthdate',
              ),
              onTap: () => _selectDate(context), // Show date picker on tap
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: _isHovering,
              builder: (context, isHovering, child) {
                return InkWell(
                  onHover: (hovering) {
                    _isHovering.value = hovering;
                  },
                  onTap: _calculateAge,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHovering ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Text(
                      'Calculate Age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            if (_selectedDate != null)
              Text(
                'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 20),
              ),
            if (_age != null) ...[
              SizedBox(height: 16),
              Text(
                'Your age is: $_age years',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
