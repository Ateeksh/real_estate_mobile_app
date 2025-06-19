import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, dynamic> responses;
  final double baseRate;
  final double totalAdj;
  final double adoptedRate;
  final double fmv;

  const SummaryPage({
    Key? key,
    required this.responses,
    required this.baseRate,
    required this.totalAdj,
    required this.adoptedRate,
    required this.fmv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valuation Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fair Market Value: Rs. ${fmv.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Base Rate: Rs. ${baseRate.toStringAsFixed(2)}/sq.ft'),
            Text('Total Adjustment: ${totalAdj.toStringAsFixed(2)}%'),
            Text('Adopted Rate: Rs. ${adoptedRate.toStringAsFixed(2)}/sq.ft'),
            const SizedBox(height: 20),
            const Text(
              'Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...responses.entries.map((entry) {
              return Text('${entry.key}: ${entry.value}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
