// ignore_for_file: invalid_use_of_protected_member

import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OrderController ordersController = Get.put(OrderController());
    return Obx(
      () => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ordersController.orders.value.length,
          itemBuilder: (context, index) {
            return Obx(
              () => OrderCardWidget(
                shipment: ordersController.orders.value[index],
                cost: ordersController.orders.value[index].shippingCost
                            .toString() ==
                        "0"
                    ? "Waiting estimation"
                    : ordersController.orders.value[index].shippingCost
                        .toString(),
                date: ordersController.orders.value[index].submitedDate,
                from: ordersController.orders.value[index].senderAddress,
                id: ordersController.orders.value[index].shipmentId,
                status: ordersController
                            .orders.value[index].shipmentStatus.name ==
                        ShipmentStatus.waitingApproval.name
                    ? "Waiting Approval"
                    : ordersController
                                .orders.value[index].shipmentStatus.name ==
                            ShipmentStatus.onHold.name
                        ? "On Hold"
                        : ordersController
                                    .orders.value[index].shipmentStatus.name ==
                                ShipmentStatus.cancelled.name
                            ? "Cancelled"
                            : ordersController.orders.value[index]
                                        .shipmentStatus.name ==
                                    ShipmentStatus.delivered.name
                                ? "Delivered"
                                : ordersController.orders.value[index]
                                            .shipmentStatus.name ==
                                        ShipmentStatus.unLoading.name
                                    ? "Unloading"
                                    : ordersController.orders.value[index]
                                                .shipmentStatus.name ==
                                            ShipmentStatus.waitingPickup.name
                                        ? "Waiting Pickup"
                                        : ordersController.orders.value[index]
                                                    .shipmentStatus.name ==
                                                ShipmentStatus
                                                    .waitngPayment.name
                                            ? "Waiting Payment"
                                            : "In Transit",
                to: ordersController.orders[index].receiverAddress,
              ),
            );
          }),
    );
  }
}
