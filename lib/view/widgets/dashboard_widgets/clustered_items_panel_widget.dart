import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project_admin_website/controller/map_controller.dart';

class ClusteredItemsPanelWidget extends StatelessWidget {
  final List<ShipmentModel> shipments;
  final Function(String shipmentId) onShipmentTapped;

  const ClusteredItemsPanelWidget({
    super.key,
    required this.shipments,
    required this.onShipmentTapped,
  });

  @override
  Widget build(BuildContext context) {
    final AdminMapController controller = Get.find();

    return Container(
      width: 350,
      height: 400, // Give it a fixed height to be scrollable
      decoration: BoxDecoration(
        color: Kcolor.background,
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
        children: [
          // --- Panel Header ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Kcolor.primary.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${shipments.length} Shipments at this Location",
                  style: appStyle(
                      size: 16,
                      color: Kcolor.background,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Kcolor.background),
                  onPressed: () => controller.clearSelection(),
                ),
              ],
            ),
          ),
          // --- Scrollable List ---
          Expanded(
            child: ListView.builder(
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return ListTile(
                  title: Text("ID: ${shipment.shipmentId}",
                      style: appStyle(
                          size: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  subtitle: Text("Status: ${shipment.shipmentStatus.name}",
                      style: appStyle(
                          size: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500)),
                  onTap: () => onShipmentTapped(shipment.shipmentId),
                  leading: Icon(_getIconForStatus(shipment.shipmentStatus),
                      color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStatus(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.inTransit:
        return Icons.local_shipping;
      case ShipmentStatus.delivered:
        return Icons.check_circle;
      case ShipmentStatus.enteredPort:
        return Icons.anchor;
      case ShipmentStatus.unLoaded:
        return Icons.inventory_2;
      case ShipmentStatus.waitingPickup:
        return Icons.person;
      default:
        return Icons.help;
    }
  }
}
