import 'package:flutter/material.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';

enum TimeRange { oneDay, oneWeek, oneMonth, oneYear, all }

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  bool _isBalanceVisible = true;
  TimeRange _selectedRange = TimeRange.oneDay;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Transaction> _allTransactions = [
    Transaction(
      name: 'Mendes Sparrow',
      method: 'Master card',
      amount: -5980,
      date: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Transaction(
      name: 'Lily Joseph',
      method: 'Paypal',
      amount: -2680,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      name: 'Johnson Lier',
      method: 'Mastercard',
      amount: -1259,
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Transaction(
      name: 'Dwane Horrow',
      method: 'Paypal',
      amount: -9586,
      date: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Transaction(
      name: 'Jessica Markos',
      method: 'Paypal',
      amount: -1658,
      date: DateTime.now().subtract(const Duration(days: 370)),
    ),
  ];

  List<Transaction> get _filteredTransactions {
    final now = DateTime.now();
    List<Transaction> filtered;

    switch (_selectedRange) {
      case TimeRange.oneDay:
        filtered =
            _allTransactions
                .where(
                  (tx) =>
                      tx.date.isAfter(now.subtract(const Duration(days: 1))),
                )
                .toList();
        break;
      case TimeRange.oneWeek:
        filtered =
            _allTransactions
                .where(
                  (tx) =>
                      tx.date.isAfter(now.subtract(const Duration(days: 7))),
                )
                .toList();
        break;
      case TimeRange.oneMonth:
        filtered =
            _allTransactions
                .where(
                  (tx) =>
                      tx.date.isAfter(now.subtract(const Duration(days: 30))),
                )
                .toList();
        break;
      case TimeRange.oneYear:
        filtered =
            _allTransactions
                .where(
                  (tx) =>
                      tx.date.isAfter(now.subtract(const Duration(days: 365))),
                )
                .toList();
        break;
      case TimeRange.all:
        filtered = _allTransactions;
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (tx) =>
                    tx.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    return filtered;
  }

  void _selectTimeRange(TimeRange range) {
    setState(() {
      _selectedRange = range;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Spending",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.menu, color: AppColors.primaryColor),
            onPressed: null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Balance
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(AppConstants.spacing16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Account Balance",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing8),
                      Text(
                        _isBalanceVisible ? "\$24,960" : "••••••",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap:
                        () => setState(
                          () => _isBalanceVisible = !_isBalanceVisible,
                        ),
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacing24),

            // Filter Chips
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(AppConstants.spacing16),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeChip('1D', TimeRange.oneDay),
                  _buildTimeChip('1W', TimeRange.oneWeek),
                  _buildTimeChip('1M', TimeRange.oneMonth),
                  _buildTimeChip('1Y', TimeRange.oneYear),
                  _buildTimeChip('All', TimeRange.all),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacing24),

            // Activity Label + Search
            Row(
              children: [
                const Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamily,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: AppConstants.spacing8),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      2 /
                      3, // Or full width depending on design
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black87),
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Search transaction...',
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.secondaryColor,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.secondaryColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacing16),

            // Transaction List
            Expanded(
              child:
                  _filteredTransactions.isNotEmpty
                      ? ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final tx = _filteredTransactions[index];
                          return _ActivityItem(
                            name: tx.name,
                            method: tx.method,
                            amount: "-\$${tx.amount.toStringAsFixed(0)}",
                          );
                        },
                      )
                      : const Center(
                        child: Text(
                          "No transactions found",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, TimeRange range) {
    final isSelected = _selectedRange == range;
    return GestureDetector(
      onTap: () => _selectTimeRange(range),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ),
    );
  }
}

// Transaction Model
class Transaction {
  final String name;
  final String method;
  final double amount;
  final DateTime date;

  Transaction({
    required this.name,
    required this.method,
    required this.amount,
    required this.date,
  });
}

// Reusable List Item
class _ActivityItem extends StatelessWidget {
  final String name;
  final String method;
  final String amount;

  const _ActivityItem({
    required this.name,
    required this.method,
    required this.amount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.secondaryColor,
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing4),
                Text(
                  method,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
