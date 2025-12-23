import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
class AnalyticsConstants {
 static const Map<String, Color> categoryColors = {'food': AppColors.warning, 'ride': AppColors.accent, 'mart': AppColors.success, 'bill': AppColors.secondary, 'entertainment': AppColors.primary};
 static const Color defaultCategoryColor = Colors.grey;
 static const List<String> trendPeriods = ['Week', 'Month', 'Year'];
 static const List<Map<String, String>> availableReports = [
  {'name': 'Monthly Statement', 'format': 'CSV'},
  {'name': 'Annual Report', 'format': 'TXT'},
  {'name': 'Tax Document', 'format': 'TXT'},
  {'name': 'Transaction Log', 'format': 'CSV'},
 ];
 static const String loginRequired = 'Please Login To View Analytics';
 static const String spendingTitle = 'Spending Analytics';
 static const String totalSpendingLabel = 'Total Spending';
 static const String errorPrefix = 'Error: ';
 static const String budgetTitle = 'Budget Vs Actual';
 static const String editBudgetPrefix = 'Edit ';
 static const String budgetSuffix = ' Budget';
 static const String budgetLimitLabel = 'Budget Limit';
 static const String cancelButton = 'Cancel';
 static const String saveButton = 'Save';
 static const String budgetUpdatedSuffix = ' Budget Updated';
 static const String errorLoadingBudgets = 'Error Loading Budgets';
 static const String budgetPrefix = 'Budget: ';
 static const String actualPrefix = 'Actual: ';
 static const String goalsTitle = 'Financial Goals';
 static const String addGoalTitle = 'Add New Goal';
 static const String goalTitleLabel = 'Goal Title';
 static const String targetAmountLabel = 'Target Amount';
 static const String currentProgressLabel = 'Current Progress';
 static const String createButton = 'Create';
 static const String goalCreatedSuccess = 'Goal Created Successfully';
 static const String updateProgressTitle = 'Update Progress';
 static const String amountToAddLabel = 'Amount To Add';
 static const String updateButton = 'Update';
 static const String progressUpdatedSuccess = 'Progress Updated Successfully';
 static const String deleteGoalTitle = 'Delete Goal';
 static const String deleteGoalConfirm = 'Are You Sure You Want To Delete This Goal?';
 static const String deleteButton = 'Delete';
 static const String goalDeletedSuccess = 'Goal Deleted Successfully';
 static const String noGoalsYet = 'No Goals Yet';
 static const String createFirstGoalHint = 'Tap + To Create Your First Goal';
 static const String errorLoadingGoals = 'Error Loading Goals';
 static const String addProgressButton = 'Add Progress';
 static const String trendsTitle = 'Spending Trends';
 static const String overviewSuffix = ' Overview';
 static const String incomeTitle = 'Income Analytics';
 static const String totalIncomeLabel = 'Total Income';
 static const String incomeSourceDefault = 'Income Source';
 static const String reportsTitle = 'Export Reports';
 static const String loginFirstError = 'Please Login First';
 static const String generatingPrefix = 'Generating ';
 static const String savedToPrefix = 'Saved To ';
 static const String okButton = 'OK';
 static const String savingsTitle = 'Savings Tracker';
 static const String totalSavingsLabel = 'Total Savings';
 static const String thisMonthLabel = 'This Month';
 static const String goalLabel = 'Goal';
 static const String categoryTitle = 'Category Breakdown';
 static const String errorLoadingCategories = 'Error Loading Categories';
 static const String comparisonTitle = 'Monthly Comparison';
 static const String spendingLabel = 'Spending';
 static const String incomeLabel = 'Income';
 static const String netLabel = 'Net';
 static const String investmentTitle = 'Investment Portfolio';
 static const String portfolioValueLabel = 'Portfolio Value';
 static const String taxTitle = 'Tax Summary';
 static const String estimatedTaxLabel = 'Estimated Tax';
}