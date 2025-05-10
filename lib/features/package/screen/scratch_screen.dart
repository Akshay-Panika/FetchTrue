import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class ScratchScreen extends StatefulWidget {
  @override
  _ScratchScreenState createState() => _ScratchScreenState();
}

class _ScratchScreenState extends State<ScratchScreen> {
  bool _scratched = false;

  // Future<void> _setScratched() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('scratched', true);
  // }

  @override
  Widget build(BuildContext context) {
     Dimensions dimensions = Dimensions(context);
    return Scaffold(
      //appBar: const CustomAppBar(title: 'Scratch Screen'),
      body: Container(
        decoration: const BoxDecoration(
            // image: DecorationImage(image: AssetImage('assets/package/bgImg/bkgImg.jpg'),fit: BoxFit.cover,opacity: 0.15)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Text('CONGRATULATIONS!🎉', style: textStyle22(context, fontWeight: FontWeight.bold, color: Colors.blue),),
            Text('Here is your scratch card', style: textStyle16(context, color: Colors.grey),),
            SizedBox(height: dimensions.screenHeight*0.06,),

            /// Scratcher
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(dimensions.screenHeight*0.02),
                child: Scratcher(
                  brushSize: 50,
                  threshold: 50,
                  color: Colors.grey,
                  onChange: (value) {
                    if (value > 50 && !_scratched) {
                      setState(() {
                        _scratched = true;
                      });
                      // _setScratched();
                      Future.delayed(Duration(seconds: 4), () {Navigator.pop(context, true);});
                    }
                  },
                  child: CustomContainer(
                    height: dimensions.screenHeight*0.3,
                    width: dimensions.screenHeight*0.3,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    borderColor: Colors.blue,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('85%', style: TextStyle(color: Colors.blue,fontSize: 35, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        Text('Discount', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: dimensions.screenHeight*0.03,),

            Text('Pre Launch Discount', style: textStyle22(context, fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(height: dimensions.screenHeight*0.05,),

          ],
        ),
      ),
    );
  }
}