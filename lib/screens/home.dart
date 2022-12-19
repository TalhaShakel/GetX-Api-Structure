import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_api_structure/Models/models.dart';
import 'package:getx_api_structure/controllers/controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<Controller>();

    return Scaffold(
        body: Obx(
      () => _controller.isLoading.value
          ? Center(child: const CircularProgressIndicator())
          : ListView.builder(
              itemCount: _controller.resdata.length,
              itemBuilder: (context, index) {
                print(_controller.resdata.length);
                var data = _controller.resdata[index];
                User userdataaa = User.fromJson(data);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('albumID ${_controller.resdata.length}'),
                    Text('albumID ${userdataaa.albumId}'),
                    Text('ID: ${userdataaa.id}'),
                    Text('title:${userdataaa.title}'),
                    Image.network(userdataaa.thumbnailUrl.toString()),
                  ],
                );
              }),
    ));
  }
}
