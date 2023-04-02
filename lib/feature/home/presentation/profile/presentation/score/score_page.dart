import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';

class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 284.h,
              color: ColorStyles.purpleA401C4,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 60.h),
                      Padding(
                        padding: EdgeInsets.only(left: 25.w, right: 28.w),
                        child: SizedBox(
                          height: 24.h,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Transform.rotate(
                                    angle: pi,
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_right.svg',
                                      color: ColorStyles.greyDADADA,
                                    )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Баллы',
                                    style: CustomTextStyle.white_21_w700,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/spiderman.png',
                                  height: 113.h,
                                  width: 113.h,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'ЧЕЛОВЕК ПАУК',
                                  style: CustomTextStyle.white_11_w900,
                                )
                              ],
                            ),
                            SizedBox(width: 23.h),
                            SizedBox(
                              height: 150.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '850\nБаллов',
                                    style: CustomTextStyle.white_33_w800,
                                  ),
                                  // Text(
                                  //   'Баллов',
                                  //   style: CustomTextStyle.white_32_w800,
                                  // ),
                                  Text(
                                    "Сколько уровней я могу\nдостичь",
                                    style: CustomTextStyle.white_13_w400
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    height: 29.h,
                                    // width: 160.w,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: ColorStyles.whiteFFFFFF,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Поделиться статусом',
                                          style: CustomTextStyle
                                              .black_11_w500_171716,
                                        ),
                                        const SizedBox(
                                          width: 9,
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/share.svg',
                                          color: ColorStyles.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                    child: Text(
                      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet',
                      style: CustomTextStyle.black_13_w400_171716,
                    ),
                  ),
                  itemScore('assets/images/spiderman.png', 'Человек паук'),
                  SizedBox(height: 18.h),
                  itemScore('assets/images/rassomaha.png', 'Рассомаха'),
                  SizedBox(height: 18.h),
                  itemScore('assets/images/hulk.png', 'Халк'),
                  SizedBox(height: 18.h),
                  itemScore('assets/images/batman.png', 'Бэтмен'),
                  SizedBox(height: 18.h),
                  itemScore('assets/images/america.png', 'Супер Мэн'),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemScore(String icon, String title) {
    return Container(
      height: 69.h,
      width: 372.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: ColorStyles.whiteFFFFFF,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: ColorStyles.shadowFC6554,
            blurRadius: 45,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 50.h,
            width: 50.h,
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextStyle.purple_13_w600,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: 230.w,
                child: Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
                  style: CustomTextStyle.black_11_w400_515150,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}