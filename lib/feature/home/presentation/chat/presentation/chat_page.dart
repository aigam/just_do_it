import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:scale_button/scale_button.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Chat> listChat = [
    Chat(
      date: '14.04.2022',
      name: 'Eleanor Pena',
      message: 'Amet minim mollit non deserunt ullamco est sit...',
      typeWork: 'Ремонт стиральной машинки',
    ),
    Chat(
      date: '6.19.2022',
      name: 'Brooklyn Simmons',
      message: 'Amet minim mollit non deserunt ullamco est sit...',
      typeWork: 'Адвокатская помощь',
    ),
    Chat(
      date: '8.16.2022',
      name: 'Robert Fox',
      message: 'Amet minim mollit non deserunt ullamco est sit...',
      typeWork: 'Компютерная помощь',
    ),
    Chat(
      date: '14.02.2022',
      name: 'Ronald Richards',
      message: 'Amet minim mollit non deserunt ullamco est sit...',
      typeWork: 'Репетитор',
    ),
    Chat(
      date: '16.02.2022',
      name: 'Arlene McCoy',
      message: 'Amet minim mollit non deserunt ullamco est sit...',
      typeWork: 'Дизайнер на час',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: Row(
                children: [
                  Text(
                    'Сообщения',
                    style: CustomTextStyle.black_20_w700,
                  ),
                  const Spacer(),
                  SizedBox(width: 23.w),
                  SvgPicture.asset('assets/icons/category.svg'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: listChat.length,
                itemBuilder: ((context, index) {
                  return itemChatMessage(listChat[index]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemChatMessage(Chat chat) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () {
          Navigator.of(context).pushNamed(AppRoute.personalChat);
        },
        duration: const Duration(milliseconds: 50),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: ColorStyles.greyF6F7F7,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: SvgPicture.asset('assets/icons/user.svg'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.h),
                  SizedBox(
                    width: 265.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              chat.name,
                              style: CustomTextStyle.black_12_w400_000000,
                            ),
                            const Spacer(),
                            Text(
                              chat.date,
                              style: CustomTextStyle.grey_10_w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Text('data'),
                        Text(
                          chat.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.black_12_w400_171716,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          chat.typeWork,
                          style: CustomTextStyle.grey_12_w400,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: ColorStyles.greyF7F7F8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
