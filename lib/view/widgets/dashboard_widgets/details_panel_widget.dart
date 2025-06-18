import 'package:final_project_admin_website/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:final_project_admin_website/constants/colors.dart'; // Assuming you have this
import 'package:final_project_admin_website/constants/text.dart'; // Assuming you have this

class DetailsPanelWidget extends StatelessWidget {
  final ShipmentModel shipment;
  final CustomerModel? customer;

  const DetailsPanelWidget({
    Key? key,
    required this.shipment,
    this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminMapController controller = Get.find();

    return Container(
      width: 350, // Panel width
      decoration: BoxDecoration(
        color: Kcolor.background, // Use your theme's background color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Panel Header ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Kcolor.primary
                  .withOpacity(0.8), // Use your theme's primary color
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shipment Details",
                  style: appStyle(
                      size: 18,
                      color: Kcolor.background,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Kcolor.background),
                  onPressed: () {
                    controller
                        .clearSelection(); // Clears selection and hides panel
                  },
                ),
              ],
            ),
          ),
          // --- Content ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow("Shipment ID:", shipment.shipmentId),
                _buildDetailRow("Customer:", customer?.companyName ?? "N/A"),
                _buildDetailRow("Status:", shipment.shipmentStatus.name),
                _buildDetailRow("Origin:", shipment.senderAddress),
                _buildDetailRow("Destination:", shipment.receiverAddress),
                _buildDetailRow("ETA:", shipment.estimatedDeliveryDate),
                _buildDetailRow("Cargo:",
                    "${shipment.shipmentType} (${shipment.shipmentWeight} kg)"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create a formatted row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Fixed width for labels
            child: Text(
              label,
              style: appStyle(
                  size: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: appStyle(
                  size: 14, color: Kcolor.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
