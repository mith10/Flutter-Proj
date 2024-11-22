import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Statistics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          double totalAmount = 0.0;
          double paidAmount = 0.0;
          double remainingAmount = 0.0;
          int totalOrders = 0;
          int paidOrders = 0;
          int unpaidOrders = 0;

          snapshot.data!.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            double orderTotalPrice = double.parse(data['total_price']);
            double orderPaidAmount = double.parse(data['paid_amount']);
            double orderRemainingAmount = double.parse(data['remaining_amount']);

            totalAmount += orderTotalPrice;
            paidAmount += orderPaidAmount;
            remainingAmount += orderRemainingAmount;

            totalOrders++;
            if (orderPaidAmount == orderTotalPrice) {
              paidOrders++;
            } else {
              unpaidOrders++;
            }
          });

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Card for Order Counts
                Card(
                  color: Color.fromRGBO(255, 255, 238, 1.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Total Orders:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('$totalOrders', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Total Paid Orders:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('$paidOrders', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Total Unpaid Orders:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('$unpaidOrders', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Pie Chart Card
                Card(
                  color: Color.fromRGBO(255, 255, 238, 1.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Financial Summary',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: totalAmount,
                                  title: '\₹$totalAmount',
                                  radius: 70,
                                  showTitle: true,
                                  titleStyle: TextStyle(color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: paidAmount,
                                  title: '\₹$paidAmount',
                                  radius: 70,
                                  showTitle: true,
                                  titleStyle: TextStyle(color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: remainingAmount,
                                  title: '\₹$remainingAmount',
                                  radius: 70,
                                  showTitle: true,
                                  titleStyle: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Card for Amounts
                Card(
                  color: Color.fromRGBO(255, 255, 238, 1.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount Details',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Total Amount:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('\₹$totalAmount', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Paid Amount:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('\₹$paidAmount', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.money_off, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Remaining Amt:', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Text('\₹$remainingAmount', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
