import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {

  final onclick;
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double textSize;
  final double padding;
  final String image;
  final double imageSize;
  final double contentPadding;

  const Button({Key key, this.onclick, this.text, this.color: Colors.black, this.borderRadius=40, this.textColor=Colors.white, this.textSize=18, this.padding=10, this.image, this.imageSize=50, this.contentPadding=30,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onclick,
          style: ElevatedButton.styleFrom(
            primary: color,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)
            ),
            padding: EdgeInsets.all(padding),
          ),
          child: Row(
            mainAxisAlignment: text=='Næste'||image!=null?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
            children: [
              if(text=='Næste')
                SizedBox.shrink(),
              if(image!=null)
              Padding(
                padding:  EdgeInsets.only(left: contentPadding),
                child: SizedBox(
                  height: ScreenUtil().setHeight(imageSize),
                  width: ScreenUtil().setHeight(imageSize),
                  child: Image.asset('assets/images/$image'),
                ),
              ),
              if(image!=null)
                Expanded(child: SizedBox.shrink()),
              CustomText(text: text,size: textSize,color: textColor,),
              if(image!=null)
                Expanded(child: SizedBox.shrink()),
              if(text=='Næste')
                Icon(Icons.play_circle_fill)
            ],
          ),
        )
    );
  }
}