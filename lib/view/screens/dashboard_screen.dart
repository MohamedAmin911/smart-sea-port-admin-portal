// ignore_for_file: invalid_use_of_protected_member

import 'package:final_project_admin_website/constants/map_Style.dart';
import 'package:final_project_admin_website/controller/map_controller.dart';
import 'package:final_project_admin_website/view/widgets/dashboard_widgets/clustered_items_panel_widget.dart';
import 'package:final_project_admin_website/view/widgets/dashboard_widgets/details_panel_widget.dart';
import 'package:final_project_admin_website/view/widgets/dashboard_widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final AdminMapController controller = Get.put(AdminMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Google Map as the base layer
            Container(
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 4.w),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: GoogleMap(
                  style: KMapStyle.mapStyle,
                  onMapCreated: controller.onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(31.26, 32.30), // Port Said
                    zoom: 12,
                  ),
                  markers: controller.markers.value,
                  onTap: (_) => controller.clearSelection(),
                ),
              ),
            ),

            // Search bar positioned at the top
            Positioned(
              top: 40,
              left: 40,
              right: 40,
              child: SearchBarWidget(),
            ),

            // This logic is correct and will now work because the panels can be clicked.
            Positioned(
              top: 100,
              right: 40,
              child: Obx(() {
                if (controller.clusteredSelection.isNotEmpty) {
                  return ClusteredItemsPanelWidget(
                    shipments: controller.clusteredSelection,
                    onShipmentTapped: (shipmentId) {
                      controller.selectShipment(shipmentId);
                    },
                  );
                } else if (controller.selectedShipment.value != null) {
                  return DetailsPanelWidget(
                    shipment: controller.selectedShipment.value!,
                    customer: controller.selectedCustomer.value,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ),
          ],
        );
      }),
    );
  }
}
