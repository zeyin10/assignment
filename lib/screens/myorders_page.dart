import 'package:flutter/material.dart';
import '../models/models.dart';

class MyOrdersPage extends StatelessWidget {
  final OrderManager orderManager;

  const MyOrdersPage({super.key, required this.orderManager});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('My Tickets', style: textTheme.headlineMedium),
      ),
      body: ListView.builder(
        itemCount: orderManager.totalOrders,
        itemBuilder: (context, index) {
          return OrderTile(order: orderManager.orders[index]);
        },
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 50.0,
          height: 50.0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.local_movies,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booked',
            style: textTheme.bodyLarge,
          ),
          Text(order.getFormattedOrderInfo()),
          Text('Tickets: ${order.items.length}'),
        ],
      ),
    );
  }
}
