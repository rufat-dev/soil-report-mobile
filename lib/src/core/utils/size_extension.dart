import 'package:flutter/material.dart';
List<double> cacheWidth = List.filled(101, 0);
List<double> cacheHeight = List.filled(101, 0);
extension SizeExtension on num {

    double devicePaddingTop(BuildContext context) => (this / 100) * MediaQuery.of(context).padding.top;
    double devicePaddingBottom(BuildContext context) => (this / 100) * MediaQuery.of(context).padding.bottom;
    double deviceInsetsBottom(BuildContext context) => (this / 100) *  View.of(context).viewInsets.bottom ;
    double mediaInsetsBottom(BuildContext context) => (this / 100) *  MediaQuery.of(context).viewInsets.bottom ;

    double devicePaddingLeft(BuildContext context) => (this / 100) * MediaQuery.of(context).padding.left;
    double devicePaddingRight(BuildContext context) => (this / 100) * MediaQuery.of(context).padding.right;

    bool isKeyboardVisible(BuildContext context) => View.of(context).viewInsets.bottom > 0.0;

    double sw(BuildContext context) {
        if(cacheWidth[this.toInt()]!=0){
            return cacheWidth[this.toInt()];
        }else{
            cacheWidth[this.toInt()] = (this / 100) * MediaQuery
                .of(context)
                .size
                .width;
            return cacheWidth[this.toInt()];
        }
    }
    double sh(BuildContext context){
        if(cacheHeight[this.toInt()]!=0){
            return cacheHeight[this.toInt()];
        }else{
            cacheHeight[this.toInt()] = (this / 100) *  MediaQuery
                .of(context)
                .size
                .height;
            return cacheHeight[this.toInt()];
        }
    }
    double safeAreaW (BuildContext context) =>
        (this / 100) *
        (
            MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.left -
            MediaQuery.of(context).padding.right
        );
    double safeAreaH (BuildContext context) =>
        (this / 100) *
            (
                MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom
            );
}