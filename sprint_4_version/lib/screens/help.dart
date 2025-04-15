import 'package:flutter/material.dart';
import 'package:mukawwin_3/list/helplist.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class Help extends StatefulWidget {
  late bool? nav;
  Help({super.key, this.nav});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int numofgroup = 1;
  int numofpage = 1;
  PageController controller = PageController();
  void numofgroup1(int num) {
    setState(() {
      numofpage = num;
    });
    setState(() {
      numofgroup = ((num / 3) + 1).toInt();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: mylisthelp.length,
            onPageChanged: (index) {
              numofgroup1(index);
            },
            itemBuilder: (context, index) {
              return mylisthelp[index];
            },
          ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                widget.nav == null
                    ? Navigator.pushReplacementNamed(context, 'signin')
                    : Navigator.pushReplacementNamed(context, 'homepage');
              },
              child: SafeArea(
                child: Container(
                  width: 50, // حجم الزر
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff387f7f), // لون الزر
                    borderRadius:
                        BorderRadius.circular(8), // زوايا مستديرة اختيارية
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // لون الظل
                        offset: const Offset(5, 5), // موقع الظل (يمين وأسفل)
                        blurRadius: 5, // مدى انتشار الظل
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Skip",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight / 6,
              color: const Color.fromARGB(94, 56, 127, 127),
              alignment: const Alignment(-0.5, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.bounceOut);
                    },
                    child: const Text('Back'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$numofgroup of 4'),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3, // عدد النقاط حسب عدد الصفحات
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      numofpage == 11
                          ? widget.nav == null
                              ? Navigator.pushReplacementNamed(
                                  context, 'signin')
                              : Navigator.pushReplacementNamed(
                                  context, 'homepage')
                          : controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut);
                    },
                    child: numofpage == 11
                        ? const Text('Done')
                        : const Text('Next'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
