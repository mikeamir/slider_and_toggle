import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(SliderAndToggler());

class SliderAndToggler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SliderAndTogglerPage(),
          binding: SliderAndTogglerPageBindings(),
        ),
      ],
    );
  }
}

class SliderAndTogglerPageBindings extends Bindings {
  @override
  void dependencies() => Get.put(SliderAndTogglerPageController());
}

class SliderAndTogglerPageController extends GetxController {
  @override
  void onInit() {
    Get.put(SliderAndToggleWidgetController(), tag: 'Living Room');
    Get.put(SliderAndToggleWidgetController(), tag: 'Kitchen');
    Get.put(SliderAndToggleWidgetController(), tag: 'Bedroom');
    super.onInit();
  }
}

class SliderAndTogglerPage extends GetWidget<SliderAndTogglerPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff152869),
      body: Center(
        child: Container(
          height: context.height * 0.6,
          width: context.width * 0.9,
          child: Column(
            children: [
              SliderAndToggleWidget(
                height: (context.height * 0.5) / 3,
                width: context.width * 0.9,
                tag: 'Living Room',
                title: 'Living Room',
              ),
              SizedBox(height: context.height * 0.05),
              SliderAndToggleWidget(
                height: (Get.height * 0.5) / 3,
                width: Get.width * 0.9,
                tag: 'Kitchen',
                title: 'Kitchen',
              ),
              SizedBox(height: context.height * 0.05),
              SliderAndToggleWidget(
                height: (context.height * 0.5) / 3,
                width: context.width * 0.9,
                tag: 'Bedroom',
                title: 'Bedroom',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SliderAndToggleWidget extends StatelessWidget {
  final double height;
  final double width;
  final String tag;
  final String title;
  SliderAndToggleWidgetController controller;

  SliderAndToggleWidget({@required this.height, @required this.width, @required this.tag, @required this.title}) {
    controller = Get.find<SliderAndToggleWidgetController>(tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: width * 0.7,
            child: Row(
              children: [
                SizedBox(
                  height: height,
                  width: (width * 0.7 * 0.5),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                          heightFactor: 0.7,
                          child: Icon(Icons.lightbulb_outline, color: const Color(0xfffffffe)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                          heightFactor: 0.7,
                          child: FittedBox(
                            child: Obx(
                              () {
                                return Text(
                                  controller.isActive.value ? controller.percentage.value.floor().toString() : 'Off',
                                  style: const TextStyle(color: const Color(0xfffffffe)),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height,
                  width: (width * 0.7 * 0.5),
                  child: FractionallySizedBox(heightFactor: 0.5, child: FittedBox(child: Text(title, style: TextStyle(color: const Color(0xfffffffe))))),
                ),
              ],
            ),
          ),
          Obx(
            () {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: height,
                width: controller.isActive.value ? (width * 0.7 * (controller.percentage.value / 100)) : width,
                decoration: BoxDecoration(
                  color: controller.isActive.value ? const Color(0xfffffffe) : const Color(0xffa3a6ab),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Get.width * 0.02),
                    topRight: Radius.circular(Get.width * 0.02),
                    bottomRight: Radius.circular(Get.width * 0.02),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.7,
                height: height,
                child: Obx(
                  () {
                    return AbsorbPointer(
                      absorbing: !controller.isActive.value,
                      child: Opacity(
                        opacity: 0,
                        child: Slider(
                          value: controller.percentage.value,
                          min: 0,
                          max: 100,
                          onChanged: (double newValue) => controller.updatePercentage(newValue),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: width * 0.3,
                height: height,
                child: Center(
                  child: GestureDetector(
                    onTap: () => controller.updateIsActive(),
                    child: Obx(
                      () {
                        return AnimatedContainer(
                          width: width * 0.3 * 0.3,
                          height: height * 0.3,
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment(controller.isActive.value ? 1 : -1, 0),
                          decoration: BoxDecoration(
                            color: controller.isActive.value ? Color(0xfffd5680) : Colors.transparent.withOpacity(0),
                            borderRadius: BorderRadius.circular(300),
                          ),
                          child: Container(
                            width: (width * 0.3 * 0.3) * 0.5,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                              color: const Color(0xfffffffe),
                              borderRadius: BorderRadius.circular(300),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () {
              return ClipRRect(
                clipper: SliderAndToggleWidgetClipper(controller.percentage.value, controller.isActive.value),
                child: SizedBox(
                  height: height,
                  width: width * 0.7,
                  child: Row(
                    children: [
                      SizedBox(
                        height: height,
                        width: (width * 0.7 * 0.5),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FractionallySizedBox(
                                heightFactor: 0.7,
                                child: Icon(Icons.lightbulb_outline, color: const Color(0xff152869)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FractionallySizedBox(
                                heightFactor: 0.7,
                                child: FittedBox(
                                  child: Obx(
                                    () {
                                      return Text(
                                        controller.isActive.value ? controller.percentage.value.floor().toString() : 'Off',
                                        style: const TextStyle(color: const Color(0xff152869)),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height,
                        width: (width * 0.7 * 0.5),
                        child: FractionallySizedBox(heightFactor: 0.5, child: FittedBox(child: Text(title, style: TextStyle(color: const Color(0xff152869))))),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SliderAndToggleWidgetClipper extends CustomClipper<RRect> {
  double percentage;
  bool isActive;

  SliderAndToggleWidgetClipper(this.percentage, this.isActive);

  @override
  RRect getClip(Size size) => RRect.fromLTRBAndCorners(0, size.height, isActive ? (size.width * (percentage / 100)) : size.width, 0);

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) => true;
}

class SliderAndToggleWidgetController extends GetxController {
  RxBool isActive = false.obs;
  RxDouble percentage = 0.0.obs;

  void updateIsActive() => isActive.value = !isActive.value;
  void updatePercentage(double newValue) => percentage.value = newValue;
}
