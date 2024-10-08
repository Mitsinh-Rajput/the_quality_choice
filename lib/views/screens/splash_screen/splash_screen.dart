import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/input_decoration.dart';
import '../../base/custom_image.dart';
import 'form_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _showFirstImage = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File tempImage = File(pickedFile.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Save the image to the device's app directory
      final File localImage = await tempImage.copy('$appDocPath/${pickedFile.name}');

      // setState(() {
      Get.find<AuthController>().imageFile = localImage;
      Get.find<AuthController>().update();
      // });
    }
  }

  Future<void> _showPickerDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Gallery',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Camera',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Timer.run(() async {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
      });
      Get.find<AuthController>().controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleImage() {
    if (_showFirstImage) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFirstImage = !_showFirstImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
          body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            PageView.builder(
              controller: authController.pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: authController.images.length,
              onPageChanged: (va) {
                log("${authController.pageController.page}");
                authController.index = va;
                authController.update();
                log("$va", name: "Index");
                if (va == 0) {
                  _controller.reset();
                }
              },
              itemBuilder: (BuildContext context, int index) {
                // if (index == 0) {
                //   return CustomImage(
                //     path: authController.images[index],
                //     width: size.width,
                //     height: size.height,
                //   );
                // }
                if (index == 1) {
                  return const FormScreen();
                }

                return CustomImage(
                  path: authController.images[index],
                  width: size.width,
                  height: size.height,
                );
              },
            ),
            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() == 4)
                authController.imageFile == null
                    ? Center(
                        child: GestureDetector(
                          onTap: _showPickerDialog,
                          child: Container(
                            color: Colors.transparent,
                            child: const CustomImage(
                              path: Assets.imagesCameraBox,
                              height: 600,
                              width: 1120,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: _showPickerDialog,
                          child: Container(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 240,
                                  left: 150,
                                  child: Container(
                                    height: 25,
                                    width: 700,
                                    color: Colors.white,
                                  ),
                                ),
                                const CustomImage(
                                  path: Assets.page7IDCard12,
                                ),
                                Positioned(
                                  top: 362,
                                  left: 488,
                                  child: Image.file(
                                    authController.imageFile!,
                                    height: 100,
                                    fit: BoxFit.fill,
                                    width: 97,
                                  ),
                                ),
                                Positioned(
                                  top: 474,
                                  left: 495,
                                  child: Text(
                                    authController.twoController.text,
                                  ),
                                ),
                                Positioned(
                                  top: 490,
                                  left: 495,
                                  child: Text(
                                    authController.threeController.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() == 5)
                Stack(
                  children: [
                    Positioned(
                      top: 160,
                      left: 650,
                      child: GestureDetector(
                        onTap: () {
                          if (authController.answers[0] == "no") {
                            authController.answers[0] = "yes";
                          } else {
                            authController.answers[0] = "no";
                          }
                          authController.update();
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 170,
                          child: authController.answers[0] != "no"
                              ? const Stack(
                                  children: [
                                    Positioned(
                                      top: 41,
                                      left: 18,
                                      child: CustomImage(
                                        path: Assets.imagesGreenDot,
                                        height: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 17,
                                      left: 75,
                                      child: CustomImage(
                                        path: Assets.imagesTickmark,
                                        height: 50,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 300,
                      left: 650,
                      child: GestureDetector(
                        onTap: () {
                          if (authController.answers[1] == "no") {
                            authController.answers[1] = "yes";
                          } else {
                            authController.answers[1] = "no";
                          }
                          authController.update();
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 170,
                          child: authController.answers[1] != "no"
                              ? const Stack(
                                  children: [
                                    Positioned(
                                      top: 45,
                                      left: 18,
                                      child: CustomImage(
                                        path: Assets.imagesGreenDot,
                                        height: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 24,
                                      left: 75,
                                      child: CustomImage(
                                        path: Assets.imagesTickmark,
                                        height: 50,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 420,
                      left: 650,
                      child: GestureDetector(
                        onTap: () {
                          if (authController.answers[2] == "no") {
                            authController.answers[2] = "yes";
                          } else {
                            authController.answers[2] = "no";
                          }
                          authController.update();
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 170,
                          child: authController.answers[2] != "no"
                              ? const Stack(
                                  children: [
                                    Positioned(
                                      top: 38,
                                      left: 18,
                                      child: CustomImage(
                                        path: Assets.imagesGreenDot,
                                        height: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 17,
                                      left: 75,
                                      child: CustomImage(
                                        path: Assets.imagesTickmark,
                                        height: 50,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 525,
                      left: 650,
                      child: GestureDetector(
                        onTap: () {
                          if (authController.answers[3] == "no") {
                            authController.answers[3] = "yes";
                          } else {
                            authController.answers[3] = "no";
                          }
                          authController.update();
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 170,
                          child: authController.answers[3] != "no"
                              ? const Stack(
                                  children: [
                                    Positioned(
                                      top: 35,
                                      left: 18,
                                      child: CustomImage(
                                        path: Assets.imagesGreenDot,
                                        height: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 15,
                                      left: 75,
                                      child: CustomImage(
                                        path: Assets.imagesTickmark,
                                        height: 50,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),

            if (authController.pageController.hasClients)
              if (authController.pageController.page == 0) const HomePage(),
            if (authController.pageController.hasClients)
              if (authController.pageController.page?.round() == authController.images.length - 1) const Comments(),

            // Sync Button
            if (authController.pageController.hasClients)
              if (authController.pageController.page?.round() == 0)
                Positioned(
                  bottom: 20,
                  left: 45,
                  child: GestureDetector(
                    onTap: () async {
                      // await authController.submitForm();
                      authController.controller.forward(from: 0).then((value) async {
                        await authController.syncData();
                      });
                    },
                    child: AnimatedBuilder(
                        animation: authController.controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: authController.controller.value * 2 * 3.14159265359,
                            child: const CustomImage(
                              path: Assets.imagesSyncBlue,
                              height: 80,
                              width: 80,
                            ),
                          );
                        }),
                  ),
                ),

            // Forward Button
            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() >= 0 && authController.pageController.page!.round() != authController.images.length - 1)
                Positioned(
                  bottom: 20,
                  right: 45,
                  child: GestureDetector(
                    onTap: () async {
                      authController.forwardButton();
                    },
                    child: const CustomImage(
                      path: Assets.imagesForwardBlue,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),

            // Back Button
            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() >= 1)
                Positioned(
                  bottom: 20,
                  left: 45,
                  child: GestureDetector(
                    onTap: () async {
                      authController.pageController.previousPage(duration: const Duration(milliseconds: 50), curve: Curves.ease);
                    },
                    child: const CustomImage(
                      path: Assets.imagesBackwardBlue,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),

            // Home Button
            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() >= 0 && authController.pageController.page!.round() != authController.images.length - 1)
                Positioned(
                  top: 20,
                  right: 45,
                  child: GestureDetector(
                    onTap: () async {
                      authController.resetForm();
                    },
                    child: const CustomImage(
                      path: Assets.imagesHome,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),

            if (authController.pageController.hasClients)
              if (authController.pageController.page!.round() == authController.images.length - 1)
                Positioned(
                  bottom: 20,
                  right: 45,
                  child: GestureDetector(
                    onTap: () async {
                      authController.controller.forward(from: 0).then((value) async {
                        authController.forwardButton();
                      });
                    },
                    child: AnimatedBuilder(
                        animation: authController.controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: authController.controller.value * 2 * 3.14159265359,
                            child: const CustomImage(
                              path: Assets.imagesHome,
                              height: 80,
                              width: 80,
                            ),
                          );
                        }),
                  ),
                ),
          ],
        ),
      ));
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.only(top: size.height * 0.06),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.images2D,
          ),
        ),
      ),
    );
  }
}

class QuestionOne extends StatefulWidget {
  const QuestionOne({Key? key}) : super(key: key);

  @override
  State<QuestionOne> createState() => _QuestionOneState();
}

class _QuestionOneState extends State<QuestionOne> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.imagesBG,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const Text(
                    "1",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
                  ),
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "On an average how many patients\nwith lower uretric stone do you\ncome across/month",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 50, color: const Color(0xFF336666), height: 0, fontFamily: 'JosefinSans-Bold'),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: size.width * 0.30),
              shrinkWrap: true,
              itemCount: authController.QuestionOneOption.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      authController.QuestionOneAnswer = authController.QuestionOneOption[index];
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: authController.QuestionOneOption[index],
                        groupValue: authController.QuestionOneAnswer,
                        onChanged: (String? value) {
                          setState(() {
                            authController.QuestionOneAnswer = value!;
                          });
                        },
                        activeColor: const Color(0xFF336666),
                      ),
                      Text(
                        authController.QuestionOneOption[index],
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 40),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class QuestionTwo extends StatefulWidget {
  const QuestionTwo({Key? key}) : super(key: key);

  @override
  State<QuestionTwo> createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.imagesBG,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const Text(
                    "2",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
                  ),
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Of the lower ureteric stone patients\nseen per month what would be the approx.\n% of patients with stone size <8mm",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF336666),
                        ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: authController.QuestionSecondAnswer,
                    maxLines: 12,
                    decoration: CustomDecoration.inputDecoration(borderColor: Colors.black38),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class QuestionThree extends StatefulWidget {
  const QuestionThree({Key? key}) : super(key: key);

  @override
  State<QuestionThree> createState() => _QuestionThreeState();
}

class _QuestionThreeState extends State<QuestionThree> {
  // bool _isInit = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const Text(
                "3",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
              ),
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const SizedBox(height: 15),
              Text(
                "In your clinical practice what is the\nfirst line of medical therapy for patients\nwith lower ureteric stones <8mm",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 50, color: const Color(0xFF336666), fontWeight: FontWeight.bold, fontFamily: 'JosefinSans-Bold', height: 0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                padding: EdgeInsets.only(left: size.width * 0.30),
                shrinkWrap: true,
                itemCount: authController.QuestionThirdOption.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            authController.QuestionThirdAnswer = authController.QuestionThirdOption[index];
                            authController.update();
                          });
                        },
                        child: Row(
                          children: [
                            Radio<String>(
                              value: authController.QuestionThirdOption[index],
                              groupValue: authController.QuestionThirdAnswer,
                              onChanged: (String? value) {
                                setState(() {
                                  authController.QuestionThirdAnswer = value!;
                                  authController.update();
                                });
                              },
                              activeColor: const Color(0xFF336666),
                            ),
                            Text(
                              authController.QuestionThirdOption[index],
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (authController.QuestionThirdAnswer == "Others (Pls specify)")
                Container(
                  width: 400,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: TextField(
                    controller: authController.QuestionThirdAnswerForOther,
                    autofocus: true,
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}

class QuestionFour extends StatefulWidget {
  const QuestionFour({Key? key}) : super(key: key);

  @override
  State<QuestionFour> createState() => _QuestionFourState();
}

class _QuestionFourState extends State<QuestionFour> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const Text(
                "4",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
              ),
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const SizedBox(height: 15),
              Text(
                "Have you used the combination of\nTamsulosin + Deflazacort in your\nclinical practice",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 50, color: const Color(0xFF336666), fontWeight: FontWeight.bold, fontFamily: 'JosefinSans-Bold', height: 0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                padding: EdgeInsets.only(left: size.width * 0.30),
                shrinkWrap: true,
                itemCount: authController.QuestionFourthOption.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        authController.QuestionfourthAnswer = authController.QuestionFourthOption[index];
                        authController.update();
                      });
                    },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: authController.QuestionFourthOption[index],
                          groupValue: authController.QuestionfourthAnswer,
                          onChanged: (String? value) {
                            setState(() {
                              authController.QuestionfourthAnswer = value!;
                              authController.update();
                            });
                          },
                          activeColor: const Color(0xFF336666),
                        ),
                        Text(
                          authController.QuestionFourthOption[index],
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 40),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

class QuestionFive extends StatefulWidget {
  const QuestionFive({Key? key}) : super(key: key);

  @override
  State<QuestionFive> createState() => _QuestionFiveState();
}

class _QuestionFiveState extends State<QuestionFive> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const Text(
                "5",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
              ),
              Container(
                height: 1,
                width: 40,
                color: const Color(0xFF91c256),
              ),
              const SizedBox(height: 15),
              Text(
                "If yes, how would you rate the\ncombination on the scale of 1-5\n(1-Lowest, 5-Highest) on the basis of",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 50, color: const Color(0xFF336666), fontWeight: FontWeight.bold, fontFamily: 'JosefinSans-Bold', height: 0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                padding: EdgeInsets.only(left: size.width * 0.30),
                shrinkWrap: true,
                itemCount: authController.QuestionFifthOption.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 350,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                authController.QuestionFifthOption[index],
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 40),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: 132,
                                child: DropdownButton<String>(
                                  hint: const Text(
                                    "Select a value",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  dropdownColor: Colors.white,
                                  value: authController.QuestionfifthValues[index],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      authController.QuestionfifthValues[index] = newValue;
                                    });
                                  },
                                  items: <String>['1', '2', '3', '4', '5'].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

class QuestionSix extends StatefulWidget {
  const QuestionSix({super.key});

  @override
  State<QuestionSix> createState() => _QuestionSixState();
}

class _QuestionSixState extends State<QuestionSix> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.imagesBG,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const Text(
                    "6",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
                  ),
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "What is the average Rx duration\nof the combination in your\nclinical practice",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 50, color: const Color(0xFF336666), height: 0, fontFamily: 'JosefinSans-Bold'),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: size.width * 0.30),
              shrinkWrap: true,
              itemCount: authController.QuestionSixOption.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      authController.QuestionSixAnswer = authController.QuestionSixOption[index];
                      authController.update();
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: authController.QuestionSixOption[index],
                        groupValue: authController.QuestionSixAnswer,
                        onChanged: (String? value) {
                          setState(() {
                            authController.QuestionSixAnswer = value!;
                          });
                        },
                        activeColor: const Color(0xFF336666),
                      ),
                      Text(
                        authController.QuestionSixOption[index],
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 40),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class QuestionSeven extends StatefulWidget {
  const QuestionSeven({Key? key}) : super(key: key);

  @override
  State<QuestionSeven> createState() => _QuestionSevenState();
}

class _QuestionSevenState extends State<QuestionSeven> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.imagesBG,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const Text(
                    "7",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF336666)),
                  ),
                  Container(
                    height: 1,
                    width: 40,
                    color: const Color(0xFF91c256),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If the combination of Tamsulosin +\nDeflazacort is still not used, any specific\nreason for not using the combination in\nyour clinical practice?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 40,
                          height: 0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF336666),
                        ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: authController.QuestionSevenAnswer,
                    maxLines: 10,
                    decoration: CustomDecoration.inputDecoration(borderColor: Colors.black38),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(builder: (authController) {
      return SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.page11Page11Jpeg12,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 237,
                left: 75,
                right: 75,
                child: TextFormField(
                  controller: authController.comments,
                  maxLines: 11,
                  decoration: CustomDecoration.inputDecoration(borderRadius: 5, borderColor: Colors.black38),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
