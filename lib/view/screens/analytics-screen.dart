import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/controller/analytics_controller.dart';
import 'package:final_project_admin_website/view/widgets/analytics_screen_widgets/chart_container_widget.dart';
import 'package:final_project_admin_website/view/widgets/analytics_screen_widgets/kpi_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final AnalyticsController controller = Get.put(AnalyticsController());
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'en_US', symbol: 'EGP ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //KPI CARDS SECTION
              _buildKpiCards(),
              SizedBox(height: 30.h),

              //CHARTS SECTION
              _buildChartsGrid(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildKpiCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 20.w,
          runSpacing: 20.h,
          children: [
            KpiCardWidget(
              title: "Total Revenue",
              value: currencyFormat.format(controller.totalRevenue.value),
              icon: Icons.monetization_on,
              color: Colors.green,
            ),
            KpiCardWidget(
              title: "Total Shipments",
              value: controller.totalShipments.value.toString(),
              icon: Icons.local_shipping,
              color: Colors.blue,
            ),
            KpiCardWidget(
              title: "Active Customers",
              value: controller.activeCustomers.value.toString(),
              icon: Icons.people,
              color: Colors.orange,
            ),
            KpiCardWidget(
              title: "Pending Orders",
              value: controller.pendingOrders.value.toString(),
              icon: Icons.pending_actions,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsGrid(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 1200 ? 1 : 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: 1.8,
      children: [
        ChartContainer(
          title: 'Shipment Status Distribution',
          child: _buildPieChart(controller.shipmentStatusDistribution),
        ),
        ChartContainer(
          title: 'Top Customers by Shipments',
          child: _buildBarChart(controller.topCustomersByShipments),
        ),
        ChartContainer(
          title: 'Shipment Types',
          child: _buildDonutChart(controller.shipmentTypeDistribution),
        ),
      ],
    );
  }

  Widget _buildPieChart(Map<String, double> data) {
    if (data.isEmpty) return const Center(child: Text("No data available"));
    return PieChart(
      PieChartData(
        sections: data.entries.map((entry) {
          return PieChartSectionData(
            color: Kcolor.pieColors[data.keys.toList().indexOf(entry.key) %
                Kcolor.pieColors.length],
            value: entry.value,
            title: '${entry.key}\n(${entry.value.toInt()})',
            radius: 80,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildDonutChart(Map<String, double> data) {
    if (data.isEmpty) return const Center(child: Text("No data available"));
    return PieChart(
      PieChartData(
        sections: data.entries.map((entry) {
          return PieChartSectionData(
            color: Kcolor.pieColors.reversed.toList()[
                data.keys.toList().indexOf(entry.key) %
                    Kcolor.pieColors.length],
            value: entry.value,
            title: '${entry.key}',
            radius: 80,
            titleStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
      ),
    );
  }

  Widget _buildBarChart(List<TopCustomerData> data) {
    if (data.isEmpty) return const Center(child: Text("No data available"));
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.isNotEmpty
            ? (data
                    .map((d) => d.shipmentCount)
                    .reduce((a, b) => a > b ? a : b) *
                1.2)
            : 10,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(data[value.toInt()].name.split(' ').first,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)));
                  },
                  reservedSize: 30)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                  toY: entry.value.shipmentCount.toDouble(),
                  color: Colors.amber,
                  width: 20,
                  borderRadius: BorderRadius.circular(4))
            ],
          );
        }).toList(),
      ),
    );
  }
}
