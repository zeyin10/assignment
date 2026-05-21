import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class CheckoutPage extends StatefulWidget {
  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;

  const CheckoutPage({
    super.key,
    required this.cartManager,
    required this.didUpdate,
    required this.onSubmit,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text('Delivery'),
    1: Text('Self Pick-Up'),
  };

  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  // Glow pulse controller
  late final AnimationController _glowController;
  late final Animation<double> _glowRadius;
  late final Animation<double> _glowOpacity;

  // Press scale controller
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowRadius = Tween<double>(begin: 0, end: 18).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pressController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Select Date';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return 'Select Time';
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() => selectedSegment = segmentIndex);
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Widget _buildOrderSegmentedType() {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
            value: 0,
            label: Text('E-Ticket'),
            icon: Icon(Icons.email_outlined)),
        ButtonSegment(
            value: 1,
            label: Text('Print at Box'),
            icon: Icon(Icons.print_outlined)),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegmentSelected,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Name on Booking'),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        itemCount: widget.cartManager.items.length,
        itemBuilder: (context, index) {
          final item = widget.cartManager.itemAt(index);
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(),
            secondaryBackground: const SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.delete)],
              ),
            ),
            onDismissed: (direction) {
              setState(() => widget.cartManager.removeItem(item.id));
              widget.didUpdate();
            },
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: colorTheme.primary, width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Text('x${item.quantity}'),
                ),
              ),
              title: Text(item.name),
              subtitle: Text('Price: \$${item.price}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isDisabled = widget.cartManager.isEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    if (isDisabled) {
      return ElevatedButton(
        onPressed: null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              'Book Tickets - \$${widget.cartManager.totalCost.toStringAsFixed(2)}'),
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _pressController]),
      builder: (context, child) {
        return ScaleTransition(
          scale: _pressScale,
          child: GestureDetector(
            onTapDown: (_) => _pressController.forward(),
            onTapUp: (_) => _pressController.reverse(),
            onTapCancel: () => _pressController.reverse(),
            onTap: _handleSubmit,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary
                        .withOpacity(_glowOpacity.value),
                    blurRadius: _glowRadius.value,
                    spreadRadius: _glowRadius.value * 0.3,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      child: ElevatedButton(
        onPressed: null, // handled by GestureDetector above
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary,
          disabledForegroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              'Book Tickets - \$${widget.cartManager.totalCost.toStringAsFixed(2)}'),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final order = Order(
      selectedSegment: selectedSegment,
      selectedTime: selectedTime,
      selectedDate: selectedDate,
      name: _nameController.text,
      items: widget.cartManager.items,
    );
    widget.cartManager.resetCart();
    widget.onSubmit(order);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Booking Details', style: textTheme.headlineSmall),
            const SizedBox(height: 16.0),
            _buildOrderSegmentedType(),
            const SizedBox(height: 16.0),
            _buildTextField(),
            const SizedBox(height: 16.0),
            Row(
              children: [
                TextButton(
                  child: Text(formatDate(selectedDate)),
                  onPressed: () => _selectDate(context),
                ),
                TextButton(
                  child: Text(formatTimeOfDay(selectedTime)),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Booking Summary'),
            _buildOrderSummary(context),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}