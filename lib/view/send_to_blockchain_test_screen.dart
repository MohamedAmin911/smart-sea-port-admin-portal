import 'package:final_project_admin_website/controller/send_data_to_blockchain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostContainerScreen extends StatelessWidget {
  PostContainerScreen({Key? key}) : super(key: key);

  final BlockchainController controller = Get.put(BlockchainController());
  final TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Container to Blockchain'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: idController,
              decoration: InputDecoration(
                labelText: 'Container ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (idController.text.isNotEmpty) {
                            controller
                                .postContainerId(idController.text.trim());
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please enter a Container ID',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Post to Blockchain'),
                )),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.postSuccess.value) {
                return const Text(
                  '✅ Container posted successfully!',
                  style: TextStyle(color: Colors.green),
                );
              } else if (controller.errorMessage.isNotEmpty) {
                return Text(
                  '❌ ${controller.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
