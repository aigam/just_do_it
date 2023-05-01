import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/models/category.dart';
import 'package:just_do_it/models/category_select.dart';
import 'package:just_do_it/models/city.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatefulWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController, {super.key});

  @override
  State<SlidingPanelSearch> createState() => _SlidingPanelSearchState();
}

class _SlidingPanelSearchState extends State<SlidingPanelSearch> {
  double heightPanel = 686.h;
  bool passportAndCV = false;
  bool allCategory = false;
  bool allSubCategory = false;
  bool allCity = false;
  bool allCountry = false;
  int groupValueCity = 0;
  String str = '';
  String str2 = '';
  String strcat = '';
  String strcat2 = '';
  String strcat3 = '';
  int? groupValueCountry;
  Activities? selectActivities;
  Currency? selectCurrency;
  Countries? countryFirst;
  Regions? regionsFirst;
  List<int?> selectSubCategory = [];
  List<int?> selectCountry = [];
  int? currencySelect;
  List<int?> selectRegions = [];
  List<int?> selectTowns = [];
  List<Activities> activities = [];
  List<Countries> countries = [];
  List<Regions> regions = [];
  List<Town> towns = [];
  Activities? selectCategory;
  bool slide = false;
  List<String> isRegion = [];

  TypeFilter typeFilter = TypeFilter.main;

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  String? countryString;
  String? currencyString;
  String? category;
  String? region;

  FocusNode focusCoastMin = FocusNode();
  FocusNode focusCoastMax = FocusNode();
  FocusNode focusCoastKeyWord = FocusNode();
  int openCategory = -1;
  ScrollController mainScrollController = ScrollController();

  bool customerFlag = true;
  bool contractorFlag = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(buildWhen: (previous, current) {
      if (current is OpenSlidingPanelToState) {
        heightPanel = current.height;
        // widget.panelController.open();
        widget.panelController.animatePanelToPosition(1);
        return true;
      } else {
        heightPanel = 686.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return BlocBuilder<CountriesBloc, CountriesState>( builder: (context, state) {
        if(state is CountriesLoaded)
        {
          countries = state.country;
          regions = state.region;
          towns = state.town;
          final countrySelect = state.selectCountry;
          final regionSelect = state.selectRegion;
          final townSelect = state.selectTown;
          return SlidingUpPanel(
          controller: widget.panelController,
          renderPanelSheet: false,
          panel: panel(context, townSelect, countrySelect, regionSelect),
          onPanelSlide: (position) {
            if (position == 0) {
              BlocProvider.of<SearchBloc>(context).add(HideSlidingPanelEvent());
              typeFilter = TypeFilter.main;
              focusCoastMin.unfocus();
              focusCoastMax.unfocus();
              focusCoastKeyWord.unfocus();
              slide = false;
            }
          },
          maxHeight: heightPanel,
          minHeight: 0.h,
          backdropEnabled: true,
          backdropColor: Colors.black,
          backdropOpacity: 0.8,
          defaultPanelState: PanelState.CLOSED,
        );}
        return Container();
      });
    });
  }

  Widget panel(BuildContext context, List<Town> townsSelect, List<Countries> countriesSelect, List<Regions> regionsSelect) {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.r),
              topRight: Radius.circular(45.r),
            ),
            color: ColorStyles.whiteFFFFFF,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        typeFilter == TypeFilter.main
                            ? mainFilter()
                            : typeFilter == TypeFilter.category
                                ? categoryFirst()
                                : typeFilter == TypeFilter.category1
                                    ? categorySecond(selectActivities)
                                    : typeFilter == TypeFilter.date
                                        ? dateFilter()
                                        : typeFilter == TypeFilter.country
                                            ? countryFilter()
                                            : typeFilter == TypeFilter.region
                                                ? listRegion(countryFirst!)
                                                : typeFilter == TypeFilter.towns
                                                    ? listTowns(regionsFirst!)
                                                    : typeFilter == TypeFilter.currency
                                                        ? currency()
                                                        : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        int countField = 0;
                        widget.panelController.animatePanelToPosition(0);
                        if (coastMinController.text != '') {
                          countField++;
                        }
                        if (coastMaxController.text != '') {
                          countField++;
                        }

                        var format1 = endDate == null ? null : "${endDate?.year}-${endDate?.month}-${endDate?.day}";
                        var format2 =
                            startDate == null ? null : "${startDate?.year}-${startDate?.month}-${startDate?.day}";

                        if (keyWordController.text != '') {
                          countField++;
                        }
                        if (isRegion.isNotEmpty) {
                          countField++;
                        }
                        if (selectSubCategory.isNotEmpty) {
                          countField++;
                        }
                        if (format1 != null || format2 != null) {
                          countField++;
                        }

                        context.read<TasksBloc>().add(
                              GetTasksEvent(
                                access: access,
                                query: keyWordController.text,
                                dateEnd: format1,
                                dateStart: format2,
                                priceFrom: int.tryParse(coastMinController.text),
                                priceTo: int.tryParse(coastMaxController.text),
                                isSelectCountry: countriesSelect,
                                isSelectRegions: regionsSelect,
                                isSelectTown: townsSelect,
                                subcategory: selectSubCategory,
                                countFilter: countField,
                                currency: selectCurrency?.id,
                                customer: (contractorFlag && contractorFlag) || (contractorFlag && contractorFlag)
                                    ? null
                                    : customerFlag,
                              ),
                            );
                      },
                      btnColor: ColorStyles.yellowFFD70A,
                      textLabel: Text(
                        'Показать задания',
                        style: CustomTextStyle.black_16_w600_171716,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0 &&
                  (focusCoastMin.hasFocus || focusCoastMax.hasFocus || focusCoastKeyWord.hasFocus))
                Column(
                  children: [
                    const Spacer(),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 0),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[200],
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        slide = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 9.0,
                                            horizontal: 12.0,
                                          ),
                                          child: const Text('Готово')),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget mainFilter() {
    String date = '';
    if (startDate == null && endDate == null) {
      // date =
      //     '${DateFormat('dd.MM.yyyy').format(DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.now())}';
    } else {
      date = startDate != null ? DateFormat('dd.MM.yyyy').format(startDate!) : '';
      date += ' - ${endDate != null ? DateFormat('dd.MM.yyyy').format(endDate!) : ''}';
    }

    // else {
    //   date =
    //       startDate != null ? DateFormat('dd.MM.yyyy').format(startDate!) : '';
    //   date +=
    //       ' - ${endDate != null ? DateFormat('dd.MM.yyyy').format(endDate!) : ''}';
    // }
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5.h,
              width: 81.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: ColorStyles.blueFC6554,
              ),
            ),
          ],
        ),
        SizedBox(height: 27.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Фильтры',
                    style: CustomTextStyle.black_22_w700,
                  ),
                  const Spacer(),
                  BlocBuilder<CountriesBloc, CountriesState>(builder: (context, state) {
                    if (state is CountriesLoaded) {
                      final country = state.country;
                      final region = state.region;
                      final town = state.town;
                      return GestureDetector(
                        onTap: () {
                          for (var element in country) {
                            context.read<CountriesBloc>().add(RemoveCountryEvent(element));
                          }
                           for (var element in region) {
                            context.read<CountriesBloc>().add(RemoveRegionEvent(element));
                          }
                           for (var element in town) {
                            context.read<CountriesBloc>().add(RemoveTownEvent(element));
                          }
                          currencyString = '';
                          endDate = null;
                          startDate = null;
                          date = '';
                          category = '';
                          coastMinController.text = '';
                          coastMaxController.text = '';
                          keyWordController.text = '';
                          isRegion = [];
                          selectSubCategory = [];
                          countryString = '';
                          passportAndCV = false;
                          strcat2 = '';
                          strcat = '';
                          allCategory = false;
                          for (int i = 0; i < activities.length; i++) {
                            for (int y = 0; y < activities[i].subcategory.length; y++) {
                              activities[i].subcategory[y].isSelect = false;
                              selectSubCategory = [];
                            }
                            activities[i].isSelect = false;
                          }
                          // for (var element in regions) {
                          //   element.isSelect = false;
                          // }
                          setState(() {});
                        },
                        child: Text(
                          'Очистить',
                          style: CustomTextStyle.red_16_w400,
                        ),
                      );
                    }
                    return Container();
                  }),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        SizedBox(
          height: 510.h,
          child: ListView(
            shrinkWrap: true,
            controller: mainScrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              ScaleButton(
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.category;
                },
                bound: 0.02,
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/crown.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Категории',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              category != null && category!.isNotEmpty ? category! : 'Все категории',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.black_14_w400_171716,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.country;
                },
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'По странам',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: BlocBuilder<CountriesBloc, CountriesState>(builder: (context, state) {
                              if (state is CountriesLoaded) {
                                String str = '';
                                final contriesSelect = state.selectCountry;
                                final regionsSelect = state.selectRegion;
                                final townsSelect = state.selectTown;
                                if (townsSelect.isNotEmpty) {
                                  for (var element in townsSelect) {
                                    str += '${element.name}, ';
                                  }
                                } else {
                                  if (regionsSelect.isNotEmpty) {
                                    for (var element in regionsSelect) {
                                      str += '${element.name}, ';
                                    }
                                  } else {
                                    if (contriesSelect.isNotEmpty) {
                                      for (var element in contriesSelect) {
                                        str += '${element.name}, ';
                                      }
                                    }
                                  }
                                }
                                countryString = str;
                                if (contriesSelect.length == 1) {
                                  countryString = countryString?.replaceAll(',', '');
                                }
                                if (regionsSelect.length == 1) {
                                  countryString = countryString?.replaceAll(',', '');
                                }
                                if (townsSelect.length == 1) {
                                  countryString = countryString?.replaceAll(',', '');
                                }
                                return Text(
                                  countryString != null && countryString!.isNotEmpty ? countryString! : 'Страны не выбраны',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyle.black_14_w400_171716,
                                );
                              }
                              return Container();
                            }),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(414.h));
                  typeFilter = TypeFilter.date;
                },
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/calendar.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Даты начала и окончания',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            date,
                            style: CustomTextStyle.black_14_w400_171716,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.currency;
                },
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/wallet-money.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Валюта',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              currencyString != null && currencyString!.isNotEmpty ? currencyString! : 'Валюта не выбрана',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.black_14_w400_171716,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ScaleButton(
                      bound: 0.02,
                      onTap: () {
                        focusCoastMin.requestFocus();
                        openKeyboard();
                      },
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
                            Text(
                              'Бюджет от ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  textInputType: TextInputType.number,
                                  focusNode: focusCoastMin,
                                  actionButton: false,
                                  onTap: () {
                                    slide = true;
                                    mainScrollController.animateTo(heightPanel,
                                        duration: const Duration(seconds: 1), curve: Curves.linear);
                                    setState(() {});
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    slide = false;
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_14_w400_171716,
                                  textEditingController: coastMinController,
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
                      onTap: () {
                        focusCoastMax.requestFocus();
                        openKeyboard();
                      },
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
                            Text(
                              'Бюджет до ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  focusNode: focusCoastMax,
                                  actionButton: false,
                                  textInputType: TextInputType.number,
                                  onTap: () {
                                    slide = true;
                                    mainScrollController.animateTo(heightPanel,
                                        duration: const Duration(seconds: 1), curve: Curves.linear);
                                    setState(() {});
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    slide = false;
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_14_w400_171716,
                                  textEditingController: coastMaxController,
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
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  focusCoastKeyWord.requestFocus();
                  openKeyboard();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 99.h,
                        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/icons/quote-up-square.svg'),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ключевые слова',
                                      style: CustomTextStyle.grey_14_w400,
                                    ),
                                    Row(
                                      children: [
                                        CustomTextField(
                                          height: 60.h,
                                          width: 250.w,
                                          actionButton: false,
                                          textInputType: TextInputType.name,
                                          focusNode: focusCoastKeyWord,
                                          onTap: () {
                                            slide = true;
                                            Future.delayed(const Duration(milliseconds: 200), () {
                                              mainScrollController.animateTo(heightPanel,
                                                  duration: const Duration(seconds: 1), curve: Curves.linear);
                                            });
                                            setState(() {});
                                          },
                                          onChanged: (value) {},
                                          onFieldSubmitted: (value) {
                                            slide = false;
                                            setState(() {});
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          hintText: 'Например, покупка апельсинов..',
                                          fillColor: ColorStyles.greyF9F9F9,
                                          maxLines: 4,
                                          style: CustomTextStyle.black_14_w400_171716,
                                          textEditingController: keyWordController,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Паспортные данные загружены и есть резюме',
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                  ),
                  // const Spacer(),
                  Switch.adaptive(
                    activeColor: ColorStyles.yellowFFD70B,
                    value: passportAndCV,
                    onChanged: (value) {
                      passportAndCV = !passportAndCV;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                      value: customerFlag,
                      onChanged: (value) {
                        setState(() {
                          customerFlag = !customerFlag;
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: ColorStyles.yellowFFD70A,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Задания от заказчиков',
                    style: CustomTextStyle.black_12_w400_515150,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                      value: contractorFlag,
                      onChanged: (value) {
                        setState(() {
                          contractorFlag = !contractorFlag;
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: ColorStyles.yellowFFD70A,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Задания от исполнителей',
                    style: CustomTextStyle.black_12_w400_515150,
                  ),
                ],
              ),
              if (slide) SizedBox(height: 250.h),
            ],
          ),
        ),
      ],
    );
  }

  void openKeyboard() {
    slide = true;
    mainScrollController.animateTo(heightPanel, duration: const Duration(seconds: 1), curve: Curves.linear);
    setState(() {});
  }

  Widget currency() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
      if (state is CurrencyLoaded) {
        final currencies = state.currency;
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          children: [
            SizedBox(height: 8.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 5.h,
                  width: 81.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: ColorStyles.blueFC6554,
                  ),
                ),
              ],
            ),
            SizedBox(height: 27.h),
            Row(
              children: [
                CustomIconButton(
                  onBackPressed: () {
                    BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                    typeFilter = TypeFilter.main;
                  },
                  icon: SvgImg.arrowRight,
                ),
                SizedBox(width: 12.h),
                Text(
                  'Валюта',
                  style: CustomTextStyle.black_22_w700,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 440.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  physics: const ClampingScrollPhysics(),
                  itemCount: currencies!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        elementCurrency(
                          currencies[index],
                        ),
                      ],
                    );
                  }),
            ),
          ],
        );
      }
      return Container();
    });
  }

  Widget elementCurrency(Currency currency) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            currencyString = currency.name;
            selectCurrency = currency;
            BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
            typeFilter = TypeFilter.main;
          },
          child: Container(
            color: Colors.transparent,
            height: 50.h,
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    Text(
                      currency.name!,
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                currency.isSelect
                    ? SizedBox(
                        height: 16.h,
                      )
                    : const Divider()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryFirst() {
    activities.clear();
    activities.addAll(BlocProvider.of<AuthBloc>(context).activities);
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5.h,
              width: 81.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: ColorStyles.blueFC6554,
              ),
            ),
          ],
        ),
        SizedBox(height: 27.h),
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Text(
              'Категории',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Все категории',
                  style: CustomTextStyle.black_14_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: allCategory,
                  onChanged: (value) {
                    allCategory = !allCategory;
                    setState(() {});
                    if (allCategory == true) {
                      for (int i = 0; i < activities.length; i++) {
                        for (int y = 0; y < activities[i].subcategory.length; y++) {
                          activities[i].subcategory[y].isSelect = true;
                          selectSubCategory.add(activities[i].subcategory[y].id);
                          strcat += '${activities[i].subcategory[y].description!}, ';
                        }
                        activities[i].isSelect = true;
                      }
                      category = strcat;
                    }
                    if (allCategory == false) {
                      for (int i = 0; i < activities.length; i++) {
                        for (int y = 0; y < activities[i].subcategory.length; y++) {
                          activities[i].subcategory[y].isSelect = false;
                          selectSubCategory = [];
                        }
                        activities[i].isSelect = false;
                      }
                      category = '';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 440.h,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              physics: const ClampingScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    elementCategory(
                      activities[index].photo ?? '',
                      activities[index].description ?? '',
                      index,
                      choice: activities[index].selectSubcategory,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex, {List<String> choice = const []}) {
    String selectWork = '';
    if (choice.isNotEmpty) {
      selectWork = '- ${choice.first}';
      if (choice.length > 1) {
        for (int i = 1; i < choice.length; i++) {
          selectWork += ', ${choice[i]}';
        }
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: GestureDetector(
        onTap: () {
          selectActivities = activities[currentIndex];
          BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
          typeFilter = TypeFilter.category1;
        },
        child: Container(
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
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              if (icon != '')
                Image.network(
                  server + icon,
                  height: 20.h,
                ),
              SizedBox(width: 9.w),
              Text(
                title,
                style: CustomTextStyle.black_14_w400_171716,
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 70.w,
                    child: Text(
                      selectWork,
                      style: CustomTextStyle.grey_14_w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget itemCategory(Category category) {
  //   return GestureDetector(
  //     onTap: () {

  //     },
  //     child: Container(
  //       color: Colors.transparent,
  //       height: 50.h,
  //       child: Column(
  //         children: [
  //           const Spacer(),
  //           Row(
  //             children: [
  //               Image.asset(
  //                 category.icon,
  //                 height: 24.h,
  //               ),
  //               SizedBox(width: 12.w),
  //               Text(
  //                 category.title,
  //                 style: CustomTextStyle.black_13_w500_171716,
  //               ),
  //               const Spacer(),
  //               Icon(
  //                 Icons.arrow_forward_ios,
  //                 size: 16.h,
  //                 color: const Color(0xFFBDBDBD),
  //               )
  //             ],
  //           ),
  //           const Spacer(),
  //           const Divider()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget categorySecond(Activities? selectActivity) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5.h,
              width: 81.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: ColorStyles.blueFC6554,
              ),
            ),
          ],
        ),
        SizedBox(height: 27.h),
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.category;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                selectActivities?.description ?? '',
                style: CustomTextStyle.black_22_w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Все подкатегории',
                  style: CustomTextStyle.black_14_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: selectActivities!.isSelect,
                  onChanged: (value) {
                    strcat = '';
                    selectActivity?.isSelect = !selectActivity.isSelect;
                    for (var element in selectActivity!.subcategory) {
                      element.isSelect = value;
                      strcat += '${element.description}, ';
                      if (element.isSelect == true) {
                        selectSubCategory.add(element.id);
                      }
                      if (element.isSelect == false) {
                        selectSubCategory.remove(element.id);
                        strcat = '';
                      }
                      category = strcat;
                    }

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Column(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectActivities!.subcategory.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: ((context, index) {
              return item(index, selectActivities!);
            }),
          ),
        ]),
      ],
    );
  }

  Widget item(int index, Activities? selectActivity) {
    return GestureDetector(
      onTap: () {
        strcat2 = '';
        selectActivities!.subcategory[index].isSelect = !selectActivities!.subcategory[index].isSelect;
        setState(() {});
        if (selectActivities!.subcategory[index].isSelect == true) {
          selectSubCategory.add(selectActivities!.subcategory[index].id);
          strcat += '${selectActivities!.subcategory[index].description!}, ';
        }
        if (selectActivities!.subcategory[index].isSelect == false) {
          selectSubCategory.remove(selectActivities!.subcategory[index].id);
          allCategory = false;
          strcat2 = '${selectActivities!.subcategory[index].description!}, ';
        }
        if (selectSubCategory.isEmpty) {
          strcat = '';
          strcat2 = '';
        }

        strcat3 = strcat.replaceAll(strcat2, '');
        strcat = strcat3;
        category = strcat3;

        if (selectSubCategory.length == 1) {
          category = category?.replaceAll(',', '');
        }

        print(selectSubCategory);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
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
                      selectActivities!.subcategory[index].description ?? '',
                      style: CustomTextStyle.black_14_w400_515150,
                    ),
                  ),
                  const Spacer(),
                  if (selectActivities!.subcategory[index].isSelect && selectSubCategory != []) const Icon(Icons.check)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCategory2(CategorySelect category) {
    return GestureDetector(
      onTap: () {
        // typeFilter = TypeFilter.category1;
        // BlocProvider.of<SearchBloc>(context)
        //     .add(OpenSlidingPanelToEvent(686.h));
      },
      child: SizedBox(
        height: 62.h,
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                SizedBox(width: 12.w),
                Text(
                  category.title,
                  style: CustomTextStyle.black_14_w500_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: category.select,
                  onChanged: (value) {
                    category.select = !category.select;
                    setState(() {});
                  },
                ),
              ],
            ),
            // const Spacer(),
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget countryFilter() {
    return BlocBuilder<CountriesBloc, CountriesState>(builder: (context, state) {
      if (state is CountriesLoaded) {
        final countrySelect = state.selectCountry;
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(height: 8.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 5.h,
                  width: 81.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: ColorStyles.blueFC6554,
                  ),
                ),
              ],
            ),
            SizedBox(height: 27.h),
            Row(
              children: [
                CustomIconButton(
                  onBackPressed: () {
                    BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                    typeFilter = TypeFilter.main;
                  },
                  icon: SvgImg.arrowRight,
                ),
                SizedBox(width: 12.h),
                Text(
                  'Страны',
                  style: CustomTextStyle.black_22_w700,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ScaleButton(
              bound: 0.02,
              child: Container(
                height: 55.h,
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Text(
                      'Все страны',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      activeColor: ColorStyles.yellowFFD70B,
                      value: allCountry,
                      onChanged: (value) {
                        allCountry = !allCountry;
                        setState(() {});
                        if (value == true) {
                          for (int i = 0; i < countries.length; i++) {
                            context.read<CountriesBloc>().add(ChangeCountryEvent(countries[i]));
                          }
                          countryString = '';
                        }

                        if (value == false) {
                          for (int i = 0; i < countries.length; i++) {
                            context.read<CountriesBloc>().add(ChangeCountryEvent(countries[i]));
                          }
                          countryString = '';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 50.h),
              children: [
                Builder(
                  builder: (context) {
                    List<Widget> items = [];

                    for (int i = 0; i < countries.length; i++) {
                      items.add(itemCountry(countries[i], countrySelect));
                    }
                    return Column(
                      children: items,
                    );
                  },
                )
              ],
            ),
          ],
        );
      }
      return Container();
    });
  }

  Widget itemCountry(Countries countrySecond, List<Countries> countrySelect) {
    final isSelectedCountry = countrySelect.any((element) => countrySecond.id == element.id);
    log(isSelectedCountry.toString());
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            countryFirst = countrySecond;
            final access = BlocProvider.of<ProfileBloc>(context).access;
            context.read<CountriesBloc>().add(GetRegionEvent(access, countrySecond));
            BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
            typeFilter = TypeFilter.region;
          },
          child: Container(
            color: Colors.transparent,
            height: 50.h,
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    Text(
                      countrySecond.name!,
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        String str1 = '';
                        String str3 = '';
                        setState(() {});
                        context.read<CountriesBloc>().add(ChangeCountryEvent(countrySecond));

                        // if (countrySecond.isSelect == true) {
                        //   selectCountry.add(countrySecond.id);
                        //   str += '${countrySecond.name!}, ';
                        // }
                        // if (countrySecond.isSelect == false) {
                        //   selectCountry.remove(countrySecond.id);
                        //   str1 = '${countrySecond.name!}, ';
                        // }
                        // if (selectCountry.isEmpty) {
                        //   str = '';
                        //   str1 = '';
                        // }

                        // str3 = str.replaceAll(str1, '');
                        // log('1');
                        // str = str3;
                        // countryString = str3;

                        // if (selectCountry.length == 1) {
                        //   countryString = countryString?.replaceAll(',', '');
                        // }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 18.h,
                            width: 18.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEAECEE),
                            ),
                          ),
                          Container(
                            height: 10.h,
                            width: 10.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelectedCountry ? Colors.black : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                isSelectedCountry
                    ? SizedBox(
                        height: 16.h,
                      )
                    : const Divider()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listRegion(Countries country) {
    return BlocBuilder<CountriesBloc, CountriesState>(builder: (context, state) {
      if (state is CountriesLoaded) {
        final regionSelect = state.selectRegion;
        final isSelectedEveryRegion =
            state.region.every((region) => regionSelect.any((choosenRegion) => choosenRegion.id == region.id));
        return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              SizedBox(height: 8.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 5.h,
                    width: 81.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: ColorStyles.blueFC6554,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27.h),
              Row(
                children: [
                  CustomIconButton(
                    onBackPressed: () {
                      BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                      typeFilter = TypeFilter.country;
                    },
                    icon: SvgImg.arrowRight,
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    'Регионы',
                    style: CustomTextStyle.black_22_w700,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Все регионы',
                        style: CustomTextStyle.black_14_w400_171716,
                      ),
                      const Spacer(),
                      Switch.adaptive(
                        activeColor: ColorStyles.yellowFFD70B,
                        value: isSelectedEveryRegion,
                        onChanged: (value) {
                          for (var element in regions) {
                            context.read<CountriesBloc>().add(ChangeRegionEvent(element));
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 700.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: regions.length,
                  padding: EdgeInsets.only(left: 10.w),
                  itemBuilder: ((context, index) {
                    final isSelectedRegion = regionSelect.any((element) => regions[index].id == element.id);
                    return GestureDetector(
                      onTap: () {
                        regionsFirst = regions[index];
                        final access = BlocProvider.of<ProfileBloc>(context).access;
                        context.read<CountriesBloc>().add(GetTownsEvent(access, regions[index]));
                        BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                        typeFilter = TypeFilter.towns;
                      },
                      child: Container(
                        height: 40.h,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              regions[index].name!,
                              style: CustomTextStyle.black_14_w500_171716,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.read<CountriesBloc>().add(ChangeRegionEvent(regions[index]));
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 18.h,
                                    width: 18.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFEAECEE),
                                    ),
                                  ),
                                  Container(
                                    height: 10.h,
                                    width: 10.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelectedRegion ? Colors.black : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ]);
      }
      return Container();
    });
  }

  Widget listTowns(Regions region) {
    return BlocBuilder<CountriesBloc, CountriesState>(builder: (context, state) {
      if (state is CountriesLoaded) {
        final townSelect = state.selectTown;
        final isSelectedEveryTown =
            state.town.every((town) => townSelect.any((choosenTown) => choosenTown.id == town.id));
        return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              SizedBox(height: 8.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 5.h,
                    width: 81.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: ColorStyles.blueFC6554,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27.h),
              Row(
                children: [
                  CustomIconButton(
                    onBackPressed: () {
                      BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                      typeFilter = TypeFilter.region;
                    },
                    icon: SvgImg.arrowRight,
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    'Подрегионы',
                    style: CustomTextStyle.black_22_w700,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Все подрегионы',
                        style: CustomTextStyle.black_14_w400_171716,
                      ),
                      const Spacer(),
                      Switch.adaptive(
                        activeColor: ColorStyles.yellowFFD70B,
                        value: isSelectedEveryTown,
                        onChanged: (value) {
                          for (var element in towns) {
                            context.read<CountriesBloc>().add(ChangeTownEvent(element));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 700.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: towns.length,
                  padding: EdgeInsets.only(left: 10.w),
                  itemBuilder: ((context, index) {
                    final isSelectedTown = townSelect.any((element) => towns[index].id == element.id);
                    return GestureDetector(
                      onTap: () {
                        context.read<CountriesBloc>().add(ChangeTownEvent(towns[index]));
                        setState(() {});
                      },
                      child: Container(
                        height: 40.h,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Text(
                              towns[index].name!,
                              style: CustomTextStyle.black_14_w500_171716,
                            ),
                            const Spacer(),
                            if (isSelectedTown) const Icon(Icons.check)
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ]);
      }
      return Container();
    });
  }

  Widget dateFilter() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5.h,
              width: 81.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: ColorStyles.blueFC6554,
              ),
            ),
          ],
        ),
        SizedBox(height: 27.h),
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context).add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Text(
              'Даты начала и окончания',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
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
                    SizedBox(height: 3.h),
                    Text(
                      startDate != null
                          ? DateFormat('dd.MM.yyyy').format(startDate!)
                          : 'Выберите дату начала выполнения',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                  ],
                ),
                const Spacer(),
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
                    SizedBox(height: 3.h),
                    Text(
                      endDate != null ? DateFormat('dd.MM.yyyy').format(endDate!) : 'Выберите дату завершения задачи',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                                ),
                                onPressed: () {
                                  if (index == 0 && startDate == null) {
                                    startDate = DateTime.now();
                                  } else if (index == 1 && endDate == null) {
                                    endDate = DateTime.now();
                                  }
                                  setState(() {});
                                  Navigator.of(ctx).pop();
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
                        initialDateTime: index == 0 ? startDate : endDate,
                        minimumDate: index == 1 && startDate != null ? startDate : null,
                        maximumDate: index == 0 && endDate != null ? endDate : null,
                        onDateTimeChanged: (val) {
                          if (index == 0) {
                            startDate = val;
                          } else if (index == 1) {
                            endDate = val;
                          }
                          setState(() {});
                        }),
                  ),
                ],
              ),
            ));
  }

  DateTime? startDate;
  DateTime? endDate;
}
