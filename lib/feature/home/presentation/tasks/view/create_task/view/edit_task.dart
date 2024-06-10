import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/category_selector.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/date.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/task/task_subcategory.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditTasks extends StatefulWidget {
  final bool customer;
  final Task task;
  const EditTasks({
    required this.customer,
    super.key,
    required this.task,
  });

  @override
  State<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasks> {
  final PageController pageController = PageController();
  PanelController panelController = PanelController();
  int page = 0;

  TextEditingController aboutController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();

  List<ArrayImages> document = [];
  // List<ArrayImages> photo = [];
  bool isGraded = false;
  List<Countries> countries = [];
  Currency? currency;
  TaskCategory? selectCategory;
  TaskSubcategory? selectSubCategory;
  late UserRegModel? user;
  DateTime? startDate;
  DateTime? endDate;
  Future<void> editTask(bool isGraded) async {
    String error = 'specify'.tr();
    bool errorsFlag = false;

    if (startDate == null) {
      error += '\n- ${'starts_date'.tr().toLowerCase()}';
      errorsFlag = true;
    }
    if (endDate == null) {
      error += '\n- ${'completions_date'.tr().toLowerCase()}';
      errorsFlag = true;
    }
    if (coastMinController.text.isEmpty) {
      error += '\n- ${'minimum_price'.tr()}';
      errorsFlag = true;
    }
    if (coastMaxController.text.isEmpty) {
      error += '\n- ${'maximum_price'.tr()}';
      errorsFlag = true;
    }
    // bool countriesIsSelect = false;
    // for (var element in countries) {
    //   if (element.select) {
    //     countriesIsSelect = true;
    //   }
    // }
    // if (!countriesIsSelect) {
    //   error += '\n- страну';
    //   errorsFlag = true;
    // }

    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMinController.text.replaceAll(" ", "")) >
          int.parse(coastMaxController.text.replaceAll(" ", ""))) {
        error +=
            '\n- ${'the_minimum_budget_must_be_less_than_the_maximum'.tr()}';
        errorsFlag = true;
      }
    }
    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMinController.text.replaceAll(" ", "")) > 1000000000) {
        error += '\n- themaximum_budget_should_not_exceed'.tr();
        errorsFlag = true;
      }
    }
    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMaxController.text.replaceAll(" ", "")) > 1000000000) {
        error += '\n- themaximum_budget_should_not_exceed'.tr();
        errorsFlag = true;
      }
    }

    if (errorsFlag) {
      CustomAlert().showMessage(error);
    } else {
      if (user!.isBanned!) {
        if (widget.task.isTask!) {
          banDialog(context, 'respond_to_the_task'.tr());
        } else {
          banDialog(context, 'respond_to_the_offer'.tr());
        }
      } else {
        showLoaderWrapper(context);

        List<Countries> country = [];
        List<Regions> regions = [];
        List<Town> towns = [];

        for (var element in countries) {
          if (element.select) {
            country.add(element);
          }
        }

        for (var element in country) {
          for (var element1 in element.region) {
            if (element1.select) {
              regions.add(element1);
            }
          }
        }

        for (var element in regions) {
          for (var element1 in element.town) {
            if (element1.select) {
              towns.add(element1);
            }
          }
        }

        Task newTask = Task(
            id: widget.task.id,
            isTask: widget.task.isTask,
            name: titleController.text,
            description: aboutController.text,
            status: TaskStatus.undefined,
            subcategory: selectSubCategory!,
            dateStart: DateFormat('yyyy-MM-dd').format(startDate!),
            dateEnd: DateFormat('yyyy-MM-dd').format(endDate!),
            priceFrom: int.parse(
              coastMinController.text.isEmpty
                  ? '0'
                  : coastMinController.text.replaceAll(" ", ""),
            ),
            priceTo: int.parse(
              coastMaxController.text.isEmpty
                  ? '0'
                  : coastMaxController.text.replaceAll(" ", ""),
            ),
            regions: regions,
            countries: country,
            towns: towns,
            files: document,
            currency: currency,
            isGraded: widget.task.isGraded! ? true : isGraded,
            canAppellate: true);

        final profileBloc = BlocProvider.of<ProfileBloc>(context);
        bool res = await Repository().editTask(profileBloc.access!, newTask);
        if (res) {
          if (!mounted) return;

          if (res) {
            Navigator.of(context).pop(true);
          }
          context.read<TasksBloc>().add(UpdateTaskEvent());
          BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
          Loader.hide();
        } else {
          Loader.hide();
          if (!mounted) return;

          if (widget.customer) {
            noMoney(context, 'raise_task'.tr(), 'task_to_the_top'.tr());
          } else {
            noMoney(context, 'raise_offer'.tr(), 'the_offer_to_the_top'.tr());
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task.isGradedNow == true) {
      setState(() {
        isGraded = true;
      });
    }
    for (var element in BlocProvider.of<AuthBloc>(context).categories) {
      if (widget.task.category?.id == element.id) {
        selectCategory = element;
        break;
      }
    }

    currency = widget.task.currency;
    selectSubCategory = widget.task.subcategory;
    aboutController.text = widget.task.description;
    titleController.text = widget.task.name;
    coastMinController.text = widget.task.priceFrom.toString();
    coastMaxController.text = widget.task.priceTo.toString();
    final splitStartDate = widget.task.dateStart.split('-');
    startDate = DateTime(int.parse(splitStartDate[0]),
        int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
    final splitEndDate = widget.task.dateEnd.split('-');
    endDate = DateTime(int.parse(splitEndDate[0]), int.parse(splitEndDate[1]),
        int.parse(splitEndDate[2]));
    initCountry();

    for (var element in widget.task.files ?? []) {
      document.add(
        ArrayImages(
          element.linkUrl!.contains(server)
              ? element.linkUrl
              : server + element.linkUrl!,
          null,
          id: element.id,
        ),
      );
    }
  }

  initCountry() async {
    countries.addAll(BlocProvider.of<CountriesBloc>(context).country);
    for (var element1 in countries) {
      element1.select = false;
    }

    for (var element1 in widget.task.countries) {
      for (var element2 in countries) {
        if (element1.id == element2.id) {
          element2.select = true;
          element2.region = await Repository().regions(element2);
        }
      }
    }

    for (var element1 in widget.task.regions) {
      for (var element2 in countries) {
        for (var element3 in element2.region) {
          if (element1.id == element3.id) {
            element3.select = true;
            element3.town = await Repository().towns(element3);
          }
        }
      }
    }

    for (var element1 in widget.task.towns) {
      for (var element2 in countries) {
        for (var element3 in element2.region) {
          for (var element4 in element3.town) {
            if (element1.id == element4.id) {
              element4.select = true;
            }
          }
        }
      }
    }
    setState(() {});
  }

  _selectImages() async {
    final getMedia = await ImagePicker().pickMultiImage();
    if (getMedia.isNotEmpty) {
      for (var element in getMedia) {
        document.add(ArrayImages(null, await element.readAsBytes(),
            file: File(element.path), type: element.path.split('.').last));
      }
    }
    setState(() {});
  }

  _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null) {
      for (var element in result.files) {
        document.add(ArrayImages(null, element.bytes,
            file: File(element.path!), type: element.path?.split('.').last));
      }
      setState(() {});
    }
  }

  void onAttach() {
    showDialog(
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                color: ColorStyles.whiteF5F5F5,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'choose_what_to_download'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                  ListTile(
                    title: Text(
                      'photo'.tr(),
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectImages();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'document'.tr(),
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectFiles();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onBackPressed: () {
                          if (page == 0) {
                            Navigator.of(context).pop();
                          } else {
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut);
                          }
                        },
                        icon: SvgImg.arrowRight,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'edity'.tr(),
                        style: CustomTextStyle.black_22_w700,
                      ),
                      Text(
                        ' ${page + 1}/2',
                        style: CustomTextStyle.grey22w700,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      page = value;
                      setState(() {});
                    },
                    children: [
                      CategorySelector(
                        customer: widget.customer,
                        bottomInsets: bottomInsets,
                        onAttach: () => onAttach(),
                        document: document,
                        selectCategory: selectCategory ?? widget.task.category,
                        selectSubCategory: selectSubCategory,
                        titleController: titleController,
                        aboutController: aboutController,
                        onEdit: (cat, subCat, title, about) {
                          selectCategory = cat;
                          selectSubCategory = subCat;
                        },
                        removefiles: (photoIndex, documentIndex) {
                          if (photoIndex != null) {
                            document.removeAt(photoIndex);
                          }
                          if (documentIndex != null) {
                            document.removeAt(documentIndex);
                          }

                          setState(() {});
                        },
                      ),
                      DatePicker(
                        isTask: widget.customer,
                        bottomInsets: bottomInsets,
                        coastMaxController: coastMaxController,
                        coastMinController: coastMinController,
                        startDate: startDate,
                        endDate: endDate,
                        allCountries: countries,
                        currecy: currency,
                        onEdit: (startDate, endDate, countries, currency,
                            isGraded) {
                          this.startDate = startDate;
                          this.endDate = endDate;
                          this.countries = countries;
                          this.currency = currency;
                          this.isGraded = isGraded;
                          setState(() {});
                        },
                        isBanned: widget.task.isBanned ?? false,
                        isGraded: isGraded,
                        saveTask: editTask,
                        isCreating: false,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: CustomButton(
                    onTap: () async {
                      if (page == 1) {
                        editTask(false);
                      } else {
                        String error = 'specify'.tr();
                        bool errorsFlag = false;

                        if (selectCategory == null) {
                          error += '\n- ${'category'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }
                        if (selectSubCategory == null) {
                          error += '\n- ${'subcategory'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }
                        if (titleController.text.isEmpty) {
                          error += '\n- ${'names'.tr()}';
                          errorsFlag = true;
                        }
                        if (aboutController.text.isEmpty) {
                          error += '\n- ${'description'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }

                        if (errorsFlag) {
                          CustomAlert().showMessage(error);
                        } else {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    btnColor: ColorStyles.yellowFFD70A,
                    textLabel: Text(
                      page == 0
                          ? 'further'.tr()
                          : widget.task.isTask!
                              ? 'edit_task'.tr()
                              : 'edit_offer'.tr(),
                      style: CustomTextStyle.black_16_w600_171716,
                    ),
                  ),
                ),
              ],
            ),
            if (bottomInsets > MediaQuery.of(context).size.height / 3)
              Positioned(
                bottom: bottomInsets,
                child: Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        onPressed: () => FocusScope.of(context).unfocus(),
                        child: Text(
                          'done'.tr(),
                          style: CustomTextStyle.blackEmpty,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
