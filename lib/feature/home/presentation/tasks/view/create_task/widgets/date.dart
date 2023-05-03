import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:scale_button/scale_button.dart';

class DatePicker extends StatefulWidget {
  double bottomInsets;
  TextEditingController coastMinController;
  TextEditingController coastMaxController;
  Function(List<Regions>, DateTime?, DateTime?, List<Countries>, List<Town>,
      Currency?) onEdit;
  DateTime? startDate;
  DateTime? endDate;
  List<Countries> selectCountry;
  List<Regions> selectRegion;
  List<Town> selectTown;
  Currency? currecy;
  DatePicker({
    super.key,
    required this.onEdit,
    required this.bottomInsets,
    required this.coastMinController,
    required this.coastMaxController,
    required this.startDate,
    required this.endDate,
    required this.selectRegion,
    required this.selectTown,
    required this.selectCountry,
    required this.currecy,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool openCountry = false;
  bool openCurrency = false;
  bool openRegion = false;
  bool openTown = false;
  ScrollController controller = ScrollController();

  void _showDatePicker(ctx, int index) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    color: Colors.white,
                    child: Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          borderRadius: BorderRadius.zero,
                          child: Text(
                            'Готово',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.black),
                          ),
                          onPressed: () {
                            if (index == 0 && widget.startDate == null) {
                              widget.startDate = DateTime.now();
                            } else if (index == 1 && widget.endDate == null) {
                              widget.endDate = DateTime.now();
                            }
                            setState(() {});
                            Navigator.of(ctx).pop();
                            widget.onEdit(
                                widget.selectRegion,
                                widget.startDate,
                                widget.endDate,
                                widget.selectCountry,
                                widget.selectTown,
                                widget.currecy);
                          },
                        ),
                        SizedBox(width: 5.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 200.h,
              color: Colors.white,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: index == 0
                      ? widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : widget.endDate ??
                          widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  minimumDate: index == 0
                      ? DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        )
                      : widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  maximumDate: index == 0
                      ? widget.endDate ??
                          DateTime(
                            DateTime.now().year + 5,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : null,
                  onDateTimeChanged: (val) {
                    if (index == 0) {
                      widget.startDate = val;
                    } else if (index == 1) {
                      widget.endDate = val;
                    }
                    widget.onEdit(
                        widget.selectRegion,
                        widget.startDate,
                        widget.endDate,
                        widget.selectCountry,
                        widget.selectTown,
                        widget.currecy);
                    setState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      List<Countries> allCountries =
          BlocProvider.of<CountriesBloc>(context).country;
      List<Regions> allRegion = BlocProvider.of<CountriesBloc>(context).region;
      List<Town> allTown = BlocProvider.of<CountriesBloc>(context).town;

      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            ScaleButton(
              bound: 0.02,
              onTap: () {
                _showDatePicker(context, 0);
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF9F9F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата начала',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                        SizedBox(height: 0.h),
                        if (widget.startDate != null)
                          Text(
                            DateFormat('dd.MM.yyyy').format(widget.startDate!),
                            style: CustomTextStyle.black_14_w400_171716,
                          ),
                      ],
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/icons/calendar.svg')
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 16.h),
                SvgPicture.asset('assets/icons/line.svg'),
              ],
            ),
            ScaleButton(
              bound: 0.02,
              onTap: () {
                _showDatePicker(context, 1);
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF9F9F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата завершения',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                        SizedBox(height: 0.h),
                        if (widget.endDate != null)
                          Text(
                            DateFormat('dd.MM.yyyy').format(widget.endDate!),
                            style: CustomTextStyle.black_14_w400_171716,
                          ),
                      ],
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/icons/calendar.svg')
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            ScaleButton(
              bound: 0.02,
              onTap: () {
                setState(() {
                  openCurrency = !openCurrency;
                });
                FocusScope.of(context).unfocus();

                Future.delayed(Duration(milliseconds: 300), () {
                  controller.animateTo(
                    controller.position.maxScrollExtent - 20.h,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                });
              },
              child: CustomTextField(
                fillColor: ColorStyles.greyF9F9F9,
                hintText: 'Валюта для оплаты заказа',
                hintStyle: CustomTextStyle.grey_14_w400,
                height: 55.h,
                enabled: false,
                suffixIcon: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [SvgPicture.asset(SvgImg.arrowRight)],
                      ),
                    ),
                  ],
                ),
                textEditingController:
                    TextEditingController(text: widget.currecy?.name),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
            ),
            SizedBox(height: 14.h),
            BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
              if (state is CurrencyLoaded) {
                final currecy = state.currency;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: openCurrency ? 160.h : 0.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: ColorStyles.shadowFC6554,
                        offset: const Offset(0, -4),
                        blurRadius: 55.r,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    children: currecy!
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                if (e.id == widget.currecy?.id) {
                                  widget.currecy = null;
                                } else {
                                  widget.currecy = e;
                                }

                                widget.onEdit([], widget.startDate,
                                    widget.endDate, [], [], widget.currecy);

                                setState(() {});
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 40.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 250.w,
                                          child: Text(
                                            e.name!,
                                            style: CustomTextStyle
                                                .black_14_w400_515150,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (widget.currecy?.id == e.id)
                                          const Icon(Icons.check)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
              return Container();
            }),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: ScaleButton(
                    bound: 0.02,
                    onTap: () {},
                    child: Container(
                      height: 55.h,
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      decoration: BoxDecoration(
                        color: ColorStyles.greyF9F9F9,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.currecy?.name == null)
                            Text(
                              'Бюджет от ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Российский рубль')
                            Text(
                              'Бюджет от ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Доллар США')
                            Text(
                              'Бюджет от \$',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Евро')
                            Text(
                              'Бюджет от €',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Дирхам')
                            Text(
                              'Бюджет от AED',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              CustomTextField(
                                height: 20.h,
                                width: 80.w,
                                textInputType: TextInputType.number,
                                actionButton: false,
                                onTap: () {
                                  openCurrency = false;
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  widget.onEdit(
                                      widget.selectRegion,
                                      widget.startDate,
                                      widget.endDate,
                                      widget.selectCountry,
                                      widget.selectTown,
                                      widget.currecy);
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {});
                                },
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                                fillColor: ColorStyles.greyF9F9F9,
                                maxLines: null,
                                style: CustomTextStyle.black_14_w400_171716,
                                textEditingController:
                                    widget.coastMinController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 21.w),
                Expanded(
                  child: ScaleButton(
                    bound: 0.02,
                    onTap: () {},
                    child: Container(
                      height: 55.h,
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      decoration: BoxDecoration(
                        color: ColorStyles.greyF9F9F9,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.currecy?.name == null)
                            Text(
                              'Бюджет до ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Российский рубль')
                            Text(
                              'Бюджет до ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Доллар США')
                            Text(
                              'Бюджет до \$',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Евро')
                            Text(
                              'Бюджет до €',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          if (widget.currecy?.name == 'Дирхам')
                            Text(
                              'Бюджет до AED',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              CustomTextField(
                                height: 20.h,
                                width: 80.w,
                                actionButton: false,
                                textInputType: TextInputType.number,
                                onTap: () {
                                  openCurrency = false;
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  widget.onEdit(
                                      widget.selectRegion,
                                      widget.startDate,
                                      widget.endDate,
                                      widget.selectCountry,
                                      widget.selectTown,
                                      widget.currecy);
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {});
                                },
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                                fillColor: ColorStyles.greyF9F9F9,
                                maxLines: null,
                                style: CustomTextStyle.black_14_w400_171716,
                                textEditingController:
                                    widget.coastMaxController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            ScaleButton(
              bound: 0.02,
              onTap: () {
                setState(() {
                  openCountry = !openCountry;
                });
                FocusScope.of(context).unfocus();

                Future.delayed(Duration(milliseconds: 300), () {
                  controller.animateTo(
                    controller.position.maxScrollExtent - 20.h,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                });
              },
              child: CustomTextField(
                fillColor: ColorStyles.greyF9F9F9,
                hintText: 'Выбрать страну',
                hintStyle: CustomTextStyle.grey_14_w400,
                height: 55.h,
                enabled: false,
                suffixIcon: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            SvgImg.earth,
                            height: 15.h,
                            width: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                textEditingController: TextEditingController(
                    text: _countriesString(widget.selectCountry)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
            ),
            SizedBox(height: 14.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: openCountry ? 80.h : 0.h,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.shadowFC6554,
                    offset: const Offset(0, -4),
                    blurRadius: 55.r,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: allCountries.map(
                  (e) {
                    bool select = false;
                    for (int i = 0; i < widget.selectCountry.length; i++) {
                      if (e.id == widget.selectCountry[i].id) {
                        select = true;
                        break;
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          List<Countries> list = widget.selectCountry;
                          if (select) {
                            list.remove(e);
                          } else {
                            list.add(e);
                          }
                          openRegion = false;
                          openTown = false;
                          widget.onEdit(
                            widget.selectRegion,
                            widget.startDate,
                            widget.endDate,
                            list,
                            widget.selectTown,
                            widget.currecy,
                          );
                          context
                              .read<CountriesBloc>()
                              .add(GetRegionEvent(list));
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 40.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 250.w,
                                    child: Text(
                                      e.name!,
                                      style:
                                          CustomTextStyle.black_14_w400_515150,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (select) const Icon(Icons.check)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(height: 14.h),
            widget.selectCountry.isNotEmpty && allRegion.isNotEmpty
                ? ScaleButton(
                    bound: 0.02,
                    onTap: () {
                      setState(() {
                        openCountry = false;
                        openRegion = !openRegion;
                      });
                      FocusScope.of(context).unfocus();

                      Future.delayed(Duration(milliseconds: 300), () {
                        controller.animateTo(
                          controller.position.maxScrollExtent - 20.h,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      });
                    },
                    child: CustomTextField(
                      fillColor: ColorStyles.greyF9F9F9,
                      hintText: 'Выбрать регион',
                      hintStyle: CustomTextStyle.grey_14_w400,
                      height: 55.h,
                      enabled: false,
                      suffixIcon: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 16.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgImg.earth,
                                  height: 15.h,
                                  width: 15.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      textEditingController: TextEditingController(
                          text: _regionsString(widget.selectRegion)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
                    ),
                  )
                : Container(),
            SizedBox(height: 14.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: openRegion ? 200.h : 0.h,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.shadowFC6554,
                    offset: const Offset(0, -4),
                    blurRadius: 55.r,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: allRegion.map(
                    (e) {
                      bool select = false;
                      for (int i = 0; i < widget.selectRegion.length; i++) {
                        if (e.id == widget.selectRegion[i].id) {
                          select = true;
                          break;
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            List<Regions> list = widget.selectRegion;
                            Regions? regDel;
                            for (int i = 0; i < list.length; i++) {
                              if (e.id == list[i].id) {
                                regDel = list[i];
                                break;
                              }
                            }

                            if (regDel != null) {
                              list.remove(regDel);
                            } else {
                              list.add(e);
                            }

                            openTown = false;

                            widget.onEdit(
                                list,
                                widget.startDate,
                                widget.endDate,
                                widget.selectCountry,
                                widget.selectTown,
                                widget.currecy);

                            context
                                .read<CountriesBloc>()
                                .add(GetTownsEvent(list));
                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 40.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        e.name!,
                                        style: CustomTextStyle
                                            .black_14_w400_515150,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (select) const Icon(Icons.check)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList()),
            ),
            SizedBox(height: 14.h),
            widget.selectRegion.isNotEmpty && allTown.isNotEmpty
                ? ScaleButton(
                    bound: 0.02,
                    onTap: () {
                      setState(() {
                        setState(() {
                          openRegion = false;
                          openTown = !openTown;
                        });
                        FocusScope.of(context).unfocus();

                        Future.delayed(Duration(milliseconds: 300), () {
                          controller.animateTo(
                            controller.position.maxScrollExtent - 20.h,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                        });
                      });
                    },
                    child: CustomTextField(
                      fillColor: ColorStyles.greyF9F9F9,
                      hintText: 'Выбрать район',
                      hintStyle: CustomTextStyle.grey_14_w400,
                      height: 55.h,
                      enabled: false,
                      suffixIcon: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 16.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgImg.earth,
                                  height: 15.h,
                                  width: 15.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      textEditingController: TextEditingController(
                          text: _townsString(widget.selectTown)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
                    ),
                  )
                : Container(),
            SizedBox(height: 14.h),
            AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: openTown ? 200.h : 0.h,
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorStyles.shadowFC6554,
                      offset: const Offset(0, -4),
                      blurRadius: 55.r,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: allTown.map(
                    (e) {
                      bool select = false;
                      for (int i = 0; i < widget.selectTown.length; i++) {
                        if (e.id == widget.selectTown[i].id) {
                          select = true;
                          break;
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            List<Town> list = widget.selectTown;
                            Town? townDel;
                            for (int i = 0; i < list.length; i++) {
                              if (e.id == list[i].id) {
                                townDel = list[i];
                                break;
                              }
                            }
                            if (townDel != null) {
                              list.remove(townDel);
                            } else {
                              list.add(e);
                            }

                            widget.onEdit(
                                widget.selectRegion,
                                widget.startDate,
                                widget.endDate,
                                widget.selectCountry,
                                list,
                                widget.currecy);

                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 40.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        e.name!,
                                        style: CustomTextStyle
                                            .black_14_w400_515150,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (select) const Icon(Icons.check)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )),
            Row(
              children: [
                const Spacer(),
                SvgPicture.asset(SvgImg.help),
              ],
            ),
            SizedBox(height: 8.h),
            CustomButton(
              onTap: () {},
              btnColor: ColorStyles.purpleA401C4,
              textLabel: Text(
                'Поднять объявление наверх',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: widget.bottomInsets),
          ],
        ),
      );
    });
  }

  String _countriesString(List<Countries> selectCountries) {
    String nameCountries = '';
    for (int i = 0; i < selectCountries.length; i++) {
      if (i == selectCountries.length - 1) {
        nameCountries += '${selectCountries[i].name}';
      } else {
        nameCountries += '${selectCountries[i].name}, ';
      }
    }
    if (selectCountries.length == 1) {
      nameCountries = nameCountries.replaceAll(',', '');
    }
    return nameCountries;
  }

  String _regionsString(List<Regions> selectRegions) {
    String nameRegions = '';
    for (int i = 0; i < selectRegions.length; i++) {
      if (i == selectRegions.length - 1) {
        nameRegions += '${selectRegions[i].name}';
      } else {
        nameRegions += '${selectRegions[i].name}, ';
      }
    }
    if (selectRegions.length == 1) {
      nameRegions = nameRegions.replaceAll(',', '');
    }
    return nameRegions;
  }

  String _townsString(List<Town> selectTowns) {
    String nameTowns = '';
    for (int i = 0; i < selectTowns.length; i++) {
      if (i == selectTowns.length - 1) {
        nameTowns += '${selectTowns[i].name}';
      } else {
        nameTowns += '${selectTowns[i].name}, ';
      }
    }
    if (selectTowns.length == 1) {
      nameTowns = nameTowns.replaceAll(',', '');
    }
    return nameTowns;
  }
}
