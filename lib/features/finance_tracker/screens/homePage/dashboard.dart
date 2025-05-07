import 'package:flutter/material.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';
import 'package:merge_app/features/finance_tracker/model/currencies.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isBalanceVisible = true;
  Currencies selectedCurrency = Currencies(
    code: 'USD',
    symbol: '\$',
    flag: '🇺🇸',
  );

  final TextEditingController _searchController = TextEditingController();

  final List<_TransactionItemData> _allTransactions = [
    _TransactionItemData(
      label: 'Job Salary',
      date: DateTime(2025, 4, 22),
      amount: 5980,
      isCredit: true,
    ),
    _TransactionItemData(
      label: 'Netflix',
      date: DateTime(2024, 9, 20),
      amount: 125.20,
      isCredit: false,
    ),
    _TransactionItemData(
      label: 'Groceries',
      date: DateTime(2024, 4, 19),
      amount: 50.20,
      isCredit: false,
    ),
    _TransactionItemData(
      label: 'Trade Income',
      date: DateTime(2024, 4, 18),
      amount: 2215.50,
      isCredit: true,
    ),
  ];

  List<_TransactionItemData> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _filterTransactions();
  }

  void _filterTransactions({Duration? dateRange}) {
    final query = _searchController.text.toLowerCase();
    final now = DateTime.now();

    setState(() {
      _filteredTransactions =
          _allTransactions.where((txn) {
            final matchesSearch = txn.label.toLowerCase().contains(query);
            final matchesDate =
                dateRange == null || txn.date.isAfter(now.subtract(dateRange));
            return matchesSearch && matchesDate;
          }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('1 Day'),
                onTap: () {
                  _filterTransactions(dateRange: Duration(days: 1));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: Text('1 Week'),
                onTap: () {
                  _filterTransactions(dateRange: Duration(days: 7));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('1 Month'),
                onTap: () {
                  _filterTransactions(dateRange: Duration(days: 30));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('1 Year'),
                onTap: () {
                  _filterTransactions(dateRange: Duration(days: 365));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: Text('Clear Filter'),
                onTap: () {
                  _filterTransactions(); // no dateRange
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(backgroundImage: AssetImage('')), // Placeholder
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              Text(
                'Frankline',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.spacing16),
            ),
            child: Row(
              children: [
                CurrencySelector(
                  onCurrencyChanged: (currency) {
                    setState(() {
                      selectedCurrency = currency;
                    });
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            SizedBox(height: AppConstants.spacing24),
            _buildSearchAndFilterBar(),
            SizedBox(height: AppConstants.spacing16),
            Expanded(child: _buildTransactionList()),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account balance',
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacing8),
                  Text(
                    isBalanceVisible
                        ? '${selectedCurrency.symbol}24,960.56'
                        : '••••••••',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isBalanceVisible
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isBalanceVisible = !isBalanceVisible;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCreditDebitCard('Credit', 5850, true),
              _buildCreditDebitCard('Debit', 2358, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditDebitCard(String label, double amount, bool isCredit) {
    return Container(
      width: 130,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isCredit ? Colors.green : Colors.red,
            child: Transform.rotate(
              angle: (isCredit ? 45 : -45) * 3.1416 / 180,
              child: Icon(
                isCredit ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              Text(
                '${selectedCurrency.symbol}${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              onPressed: _showFilterBottomSheet,
            ),
          ],
        ),
        SizedBox(height: AppConstants.spacing8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search transactions...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.spacing16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final txn = _filteredTransactions[index];
        return _TransactionItem(
          label: txn.label,
          date:
              '${txn.date.month}/${txn.date.day}/${txn.date.year}', // formatted
          amount:
              '${txn.isCredit ? '+' : '-'}${selectedCurrency.symbol}${txn.amount.toStringAsFixed(2)}',
          degree: txn.isCredit ? 45 : -45,
          icon: txn.isCredit ? Icons.arrow_upward : Icons.arrow_downward,
          backgroundColor: txn.isCredit ? Colors.green : Colors.red,
        );
      },
    );
  }
}

class _TransactionItemData {
  final String label;
  final DateTime date;
  final double amount;
  final bool isCredit;

  _TransactionItemData({
    required this.label,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class _TransactionItem extends StatelessWidget {
  final String label;
  final String date;
  final String amount;
  final IconData icon;
  final double degree;
  final Color backgroundColor;

  const _TransactionItem({
    required this.label,
    required this.date,
    required this.amount,
    required this.icon,
    required this.degree,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.spacing16),
      padding: EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Transform.rotate(
              angle: degree * 3.1416 / 180,
              child: Icon(icon, color: Colors.white),
            ),
          ),
          SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppConstants.spacing4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
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
