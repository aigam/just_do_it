import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/services/firebase_dynamic_links/firebase_dynamic_links_service.dart';
import 'package:share_plus/share_plus.dart';

void iconSelectTranslate(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            insetPadding: EdgeInsets.only(
                top: offset.dy - 10.h, left: offset.dx - 150.w, right: 20.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: onTap(0),
              child: Container(
                width: MediaQuery.of(context).size.width - 30.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        height: 40.h,
                        alignment: Alignment.center,
                        child: Text(
                          'show_original'.tr(),
                          style:
                              CustomTextStyle.sf17w400(AppColors.whitePrimary)
                                  .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void taskMoreDialog(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
  Task selectTask,
  UserRegModel? user,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 20.h, left: offset.dx - 95.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: onTap(0),
              child: Stack(
                children: [
                  Container(
                    width: 125.w,
                    height: selectTask.owner?.id != user?.id ? 72.h : 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final code = await FirebaseDynamicLinksService()
                                  .shareUserTask(
                                      int.parse(selectTask.id.toString()));
                              Share.share(code.toString());
                            },
                            child: Text(
                              'share'.tr(),
                              style: CustomTextStyle.sf17w400(
                                  AppColors.blackError),
                            ),
                          ),
                          if (selectTask.owner?.id != user?.id)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoute.contactus, arguments: [
                                  '${selectTask.name}, ${selectTask.owner!.firstname} ${selectTask.owner!.lastname}',
                                  'task_complaint'.tr()
                                ]);
                              },
                              child: Text(
                                'complain'.tr(),
                                style: CustomTextStyle.sf17w400(
                                    AppColors.blackError),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void scoreDialogRegistration(BuildContext context, String score, String action,
        {bool goToAboutProject = false}) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: 500.w,
              // height: 350.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(17.h),

              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image.asset('assets/images/ranking.png'),
                  // SizedBox(
                  //   height: 30.h,
                  // ),
                  // if (context.locale.languageCode == 'en')
                  //   Text(
                  //     '$score points ${'accrued'.tr()}',
                  //     style: CustomTextStyle.black_20_w700,
                  //   ),
                  // if (context.locale.languageCode == 'ru')
                  Text(
                      // '$score ${'points'.tr().toLowerCase()} ${'accrued'.tr()}',
                      "thank_you_for_trust".tr(),
                      textAlign: TextAlign.center,
                      style:
                          CustomTextStyle.sf21w700(AppColors.blackSecondary)),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      bottom: 15.h,
                    ),
                    child: Text(
                      'dialog_bonus_info'.tr(args: [score]),
                      style: CustomTextStyle.sf17w400(AppColors.greySecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomButton(
                    onTap: () async {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(GetProfileEvent());
                      // Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoute.about);
                    },
                    btnColor: AppColors.purplePrimary,
                    textLabel: Text(
                      // 'well'.tr(),
                      'about_project'.tr(),
                      style: CustomTextStyle.sf17w400(AppColors.whitePrimary)
                          .copyWith(fontSize: 14.5.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void scoreDialog(BuildContext context, String score, String action) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 500.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Image.asset('assets/images/ranking.png'),
                                SizedBox(
                                  height: 30.h,
                                ),
                                if (context.locale.languageCode == 'en')
                                  Text('$score points ${'accrued'.tr()}',
                                      style: CustomTextStyle.sf21w700(
                                          AppColors.blackSecondary)),
                                if (context.locale.languageCode == 'ru')
                                  Text(
                                      '$score ${'points'.tr().toLowerCase()} ${'accrued'.tr()}',
                                      style: CustomTextStyle.sf21w700(
                                          AppColors.blackSecondary)),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Text(
                                  '${'congratulations_you_are_credited'.tr()} $score ${'points_for'.tr()} $action',
                                  style: CustomTextStyle.sf17w400(
                                      AppColors.greySecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onTap: () async {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(GetProfileEvent());
                              Navigator.of(context).pop();
                            },
                            btnColor: AppColors.purplePrimary,
                            textLabel: Text(
                              'well'.tr(),
                              style: CustomTextStyle.sf17w400(
                                      AppColors.whitePrimary)
                                  .copyWith(fontSize: 14.5.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void noMoney(BuildContext context, String action, String text) => showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 327.w,
                    height: 393.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/alert_circle.svg',
                                  color: AppColors.yellowBackground,
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text('you_can_t'.tr(),
                                    style: CustomTextStyle.sf21w700(
                                        AppColors.blackSecondary)),
                                Text(
                                  action,
                                  style: CustomTextStyle.sf21w700(
                                      AppColors.blackSecondary),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Text(
                                  text,
                                  style: CustomTextStyle.sf15w400(
                                      AppColors.greySecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            btnColor: AppColors.yellowBackground,
                            textLabel: Text(
                              'back'.tr(),
                              style: CustomTextStyle.sf17w400(
                                AppColors.blackSecondary,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void banDialog(BuildContext context, String action) => showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 327.w,
                    height: 393.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/alert_circle.svg',
                                  color: AppColors.yellowBackground,
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text('unfortunately'.tr(),
                                    style: CustomTextStyle.sf21w700(
                                        AppColors.blackSecondary)),
                                Text(
                                  action,
                                  style: CustomTextStyle.sf21w700(
                                      AppColors.blackSecondary),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Text(
                                  'your_profile_is_blocked'.tr(),
                                  style: CustomTextStyle.sf15w400(
                                      AppColors.greySecondary),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Text(
                                  'contact_the_administrator_to_unblock'.tr(),
                                  style: CustomTextStyle.sf17w400(
                                      AppColors.greySecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                  AppRoute.contactus,
                                  arguments: ['', '']);
                            },
                            btnColor: AppColors.yellowBackground,
                            textLabel: Text(
                              'contact'.tr(),
                              style: CustomTextStyle.sf17w400(
                                AppColors.blackSecondary,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void helpOnTopDialog(BuildContext context, String title, String description) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 327.w,
                    height: 393.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/help_circle.svg',
                                  color: AppColors.yellowBackground,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    title,
                                    style: CustomTextStyle.sf21w700(
                                        AppColors.blackSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Text(
                                    description,
                                    style: CustomTextStyle.sf17w400(
                                      Colors.black,
                                    ).copyWith(fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            btnColor: AppColors.yellowBackground,
                            textLabel: Text(
                              'i_see'.tr(),
                              style: CustomTextStyle.sf17w400(
                                AppColors.blackSecondary,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void onTopDialog(BuildContext context, String title, String action,
        String description) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.1),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            alignment: Alignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              child: Stack(
                children: [
                  Container(
                    width: 327.w,
                    height: 393.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow_big_up_dash.svg',
                                  color: AppColors.yellowBackground,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    title,
                                    style: CustomTextStyle.sf21w700(
                                        AppColors.blackSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Text(
                                  action,
                                  style: CustomTextStyle.sf17w400(
                                    Colors.black,
                                  ).copyWith(fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Text(
                                    description,
                                    style: CustomTextStyle.sf13w400(
                                        AppColors.greySecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            btnColor: AppColors.yellowBackground,
                            textLabel: Text(
                              'i_see'.tr(),
                              style: CustomTextStyle.sf17w400(
                                AppColors.blackSecondary,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
void taskMoreDialogForProfile(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
  Owner? owner,
  UserRegModel? user,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 20.h, left: offset.dx - 95.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: onTap(0),
              child: Stack(
                children: [
                  Container(
                    width: 125.w,
                    height: owner?.id != user?.id ? 72.h : 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final code = await FirebaseDynamicLinksService()
                                  .shareUserProfile(
                                      int.parse(owner!.id.toString()));
                              Share.share(code.toString());
                            },
                            child: Text(
                              'share'.tr(),
                              style: CustomTextStyle.sf17w400(
                                  AppColors.blackError),
                            ),
                          ),
                          if (owner?.id != user?.id)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoute.contactus, arguments: [
                                  '${owner!.firstname} ${owner.lastname}',
                                  'user_complaint'.tr()
                                ]);
                              },
                              child: Text(
                                'complain'.tr(),
                                style: CustomTextStyle.sf17w400(
                                    AppColors.blackError),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
