import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:the_quality_choice/views/base/custom_image.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/input_decoration.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(
      builder: (authController) {
        return SafeArea(
          child: Container(
            width: size.height,
            height: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Assets.imagesBG,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  SizedBox(
                    width: size.width * .7,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .15,
                          child: const Text(
                            "SE Name",
                            style: TextStyle(fontFamily: 'cc-ultimatum-light', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFbf1f2e)),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: authController.oneController,
                            decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Spacer(),

                  // const Spacer(),
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  SizedBox(
                    width: size.width * .7,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .15,
                          child: const Text(
                            "HQ",
                            style: TextStyle(fontFamily: 'cc-ultimatum-light', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFbf1f2e)),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: authController.threeController,
                            decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  SizedBox(
                    width: size.width * .7,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .15,
                          child: const Text(
                            "City",
                            style: TextStyle(fontFamily: 'cc-ultimatum-light', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFbf1f2e)),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: authController.fourController,
                            decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  SizedBox(
                    width: size.width * .7,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .15,
                          child: const Text(
                            "DR Name",
                            style: TextStyle(fontFamily: 'cc-ultimatum-light', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFbf1f2e)),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: authController.twoController,
                            decoration: CustomDecoration.inputDecoration(borderColor: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomImage(
                    path: Assets.imagesTheQualityChoiceLogo,
                    height: 280,
                  )

                  // Spacer(),
                  // const Spacer(flex: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
