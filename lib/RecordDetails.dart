import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordDetailScreen extends StatefulWidget {
  final DocumentSnapshot record;

  RecordDetailScreen({required this.record});

  @override
  _RecordDetailScreenState createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late TextEditingController _paidController;
  late TextEditingController _remainingController;

  @override
  void initState() {
    super.initState();
    _paidController = TextEditingController(text: widget.record['paid_amount'].toString());
    _remainingController = TextEditingController(text: widget.record['unpaid_amount'].toString());

    _paidController.addListener(() {
      final paidAmount = double.tryParse(_paidController.text) ?? 0.0;
      final totalAmount = double.tryParse(widget.record['total_price'].toString()) ?? 0.0;
      final remainingAmount = totalAmount - paidAmount;
      _remainingController.text = remainingAmount.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _paidController.dispose();
    _remainingController.dispose();
    super.dispose();
  }

  Future<void> _updateRecord() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot = await transaction.get(widget.record.reference);
        transaction.update(freshSnapshot.reference, {
          'paid_amount': double.tryParse(_paidController.text) ?? 0.0,
          'unpaid_amount': double.tryParse(_remainingController.text) ?? 0.0,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record updated successfully')));
    } catch (e) {
      print('Error updating record: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update record')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.record['name']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Quantity: ${widget.record['quantity']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Price: ${widget.record['price']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Total Price: ${widget.record['total_price']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              TextField(
                controller: _paidController,
                decoration: InputDecoration(labelText: 'Paid Amount'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _remainingController,
                decoration: InputDecoration(labelText: 'Remaining Amount'),
                keyboardType: TextInputType.number,
                enabled: false,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateRecord,
                child: Text('Update Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
