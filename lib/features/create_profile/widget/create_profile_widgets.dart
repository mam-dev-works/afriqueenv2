import 'dart:io';
import 'package:afriqueen/common/constant/constant_colors.dart';
import 'package:afriqueen/common/constant/constant_strings.dart';
import 'package:afriqueen/common/localization/enums/enums.dart';
import 'package:afriqueen/common/utils/validators.dart';
import 'package:afriqueen/common/widgets/common_button.dart';
import 'package:afriqueen/common/widgets/common_textfield.dart';
import 'package:afriqueen/common/widgets/snackbar_message.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_bloc.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_event.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_state.dart';
import 'package:afriqueen/routes/app_routes.dart';
import 'package:afriqueen/services/location/location.dart';
import 'package:afriqueen/services/permissions/permission_handler.dart';
import 'package:afriqueen/services/storage/get_storage.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

// -----------------------------Name screen components-----------------------------------

//----------------Text Regarding name discription--------------------------
class NameDiscription extends StatelessWidget {
  const NameDiscription({super.key});

  @override
  Widget build(BuildContext context) {
    return  Text(
      EnumLocale.nameDiscription.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//----------------Text Regarding name Title--------------------------
class NameTitle extends StatelessWidget {
  const NameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.nameTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//----------------- User input for pseudo---------
class PseudoTextField extends StatelessWidget {
   PseudoTextField({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      labelText: EnumLocale.nameHintText.name.tr,
      controller: controller,
      validator: AppValidator.validatePseudo,
      obscureText: false,
      onChanged:
          (value) => context.read<CreateProfileBloc>().add(
            PseudoChanged(pseudo: value.trim()),
          ),
    );
  }
}

//------------------------Next Button ----------------------------------
class NameNextButton extends StatelessWidget {
   NameNextButton({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  final AppGetStorage app = AppGetStorage();

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          app.setPageNumber(3);
          Get.offNamed(AppRoutes.gender);
        }
      },
      buttonText: EnumLocale.next.name.tr,
    );
  }
}

// -----------------------------Gender screen components-----------------------------------

//----------------Text Regarding gender discription--------------------------
class GenderDiscription extends StatelessWidget {
  const GenderDiscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.genderDiscription.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//----------------Text Regarding gender Title--------------------------
class GenderTitle extends StatelessWidget {
  const GenderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.genderTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//------------------------Next Button ----------------------------------
class GenderNextButton extends StatelessWidget {
 GenderNextButton({super.key});

  final AppGetStorage app = AppGetStorage();

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        app.setPageNumber(4);
        Get.offNamed(AppRoutes.age);
      },
      buttonText: EnumLocale.next.name.tr,
    );
  }
}

//----------------Female gender---------------------

class Female extends StatelessWidget {
  const Female({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60.h,
        width: 225.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),

        child: Center(
          child: ListTile(
            leading: Icon(CupertinoIcons.person),
            title: Text(
              EnumLocale.genderFemale.name.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return  Radio<String>(
                  activeColor: AppColors.green,

                  value: EnumLocale.genderFemale.name.tr,
                  groupValue: state.gender,
                  onChanged:
                      (value) => context.read<CreateProfileBloc>().add(
                        GenderChanged(gender: value!),
                      ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//----------------Male gender---------------------
class Male extends StatelessWidget {
  const Male({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60.h,
        width: 225.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),

        child: Center(
          child: ListTile(
            leading: Icon(CupertinoIcons.person),
            title: Text(
              EnumLocale.genderMale.name.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Radio<String>(
                  activeColor: AppColors.green,

                  value: EnumLocale.genderMale.name.tr,
                  groupValue: state.gender,
                  onChanged:
                      (value) => context.read<CreateProfileBloc>().add(
                        GenderChanged(gender: value!),
                      ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//----------------------- Age screen------------------------

//----------------Text Regarding age discription--------------------------
class AgeDiscription extends StatelessWidget {
  const AgeDiscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.dobDiscription.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//----------------Text Regarding age Title--------------------------
class AgeTitle extends StatelessWidget {
  const AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.dobTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//------------------------Next Button ----------------------------------
class AgeNextButton extends StatelessWidget {
 AgeNextButton({super.key});

  final AppGetStorage app = AppGetStorage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return CommonButton(
          onPressed: () {
            if (DateTime.now().year - state.dob.year > 18) {
              app.setPageNumber(5);
              Get.offNamed(AppRoutes.address);
            } else {
              snackBarMessage(
                context,
                EnumLocale.ageErrorText.name.tr,
                Theme.of(context),
              );
            }
          },
          buttonText: EnumLocale.next.name.tr,
        );
      },
    );
  }
}

//--------------- Dob picker-------------------------------
class SelectDob extends StatelessWidget {
  const SelectDob({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => BottomPicker.date(
            buttonStyle: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            pickerTitle: Text(
              EnumLocale.setYourDob.name.tr,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: AppColors.primaryColor),
            ),
            dateOrder: DatePickerDateOrder.ymd,
            initialDateTime: DateTime.now(),

            minDateTime: DateTime(1950),
            pickerTextStyle: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            onChange: (index) {},
            onSubmit:
                (value) => context.read<CreateProfileBloc>().add(
                  DobChanged(dob: value),
                ),
            bottomPickerTheme: BottomPickerTheme.plumPlate,
          ).show(context),
      child: Container(
        height: 40.h,
        width: 130.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),

        child: Center(
          child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
            builder: (context, state) {
              debugPrint("${state.dob}");
              return Text(
                state.dob.toString().split(' ').first,

                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
        ),
      ),
    );
  }
}

//--------------- Address page components------------------------------

//--------------------Next Button------------------------
class AddressNextButton extends StatelessWidget {
 AddressNextButton({super.key});

  final AppGetStorage app = AppGetStorage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return CommonButton(
          onPressed: () async {
            final BuildContext currentContext = context;

            final isGranted = await AppPermission.requestLocationPermission();

            if (!currentContext.mounted) return;

            if (isGranted) {
              app.setPageNumber(6);

              Get.offNamed(AppRoutes.interests);
            } else {
              snackBarMessage(
                currentContext,
                EnumLocale.locationPermissionRequired.name.tr,
                Theme.of(currentContext),
              );
            }
          },
          buttonText: EnumLocale.next.name.tr,
        );
      },
    );
  }
}

//----------------Text Regarding Address discription--------------------------
class AddressDiscription extends StatelessWidget {
  const AddressDiscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.addressDiscription.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//----------------Text Regarding Address Title--------------------------
class AddressTitle extends StatelessWidget {
  const AddressTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.addressTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//-------------------User Location----------------------------
class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Future<List<Placemark>?>? _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getLocation();
  }

  Future<List<Placemark>?> _getLocation() async {
    bool isGranted = await AppPermission.requestLocationPermission();

    if (!isGranted) {
      await AppPermission.requestLocationPermission();
      return null;
    } else {
      final Position position = await UserLocation.determinePosition();
      return await UserLocation.geoCoding(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Country(),
        CountryName(locationFuture: _locationFuture),
        SizedBox(height: 5.h),
        City(),

        CityName(locationFuture: _locationFuture),
      ],
    );
  }
}

//------------------City name----------------------
class CityName extends StatelessWidget {
  const CityName({super.key, required Future<List<Placemark>?>? locationFuture})
    : _locationFuture = locationFuture;

  final Future<List<Placemark>?>? _locationFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Placemark>?>(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading',
            style: Theme.of(context).textTheme.bodySmall,
          ); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final currentLocation = snapshot.data!;
          return Container(
            height: 40.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.primaryColor, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                currentLocation.first.locality!.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        } else {
          return Text(
            'Location not available',
            style: Theme.of(context).textTheme.bodySmall,
          ); // Handle null data
        }
      },
    );
  }
}

//------------Country Name-----------------
class CountryName extends StatelessWidget {
  const CountryName({
    super.key,
    required Future<List<Placemark>?>? locationFuture,
  }) : _locationFuture = locationFuture;

  final Future<List<Placemark>?>? _locationFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Placemark>?>(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading',
            style: Theme.of(context).textTheme.bodySmall,
          ); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final currentLocation = snapshot.data!;
          context.read<CreateProfileBloc>().add(
            AddressChanged(
              country: currentLocation.first.country!,
              city: currentLocation.first.locality!,
            ),
          );
          return Container(
            height: 40.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.primaryColor, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                currentLocation.first.country!.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        } else {
          return Text(
            'Location not available',
            style: Theme.of(context).textTheme.bodySmall,
          ); // Handle null data
        }
      },
    );
  }
}

//--------------City-----------------
class City extends StatelessWidget {
  const City({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${EnumLocale.cityName.name.tr} :",
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

//-------------------Country----------------------
class Country extends StatelessWidget {
  const Country({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${EnumLocale.countryName.name.tr} :",
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

//----------------------------Interest screen components------------------

//-------------------Frienship inlineChoice---------------------------
class FriendshipInchoice extends StatelessWidget {
  const FriendshipInchoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return Card(
          color: AppColors.floralWhite,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),

          child: Center(
            child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Choice<String>.prompt(
                  multiple: true,
                  value: state.friendship,
                  onChanged: (value) {
                    if (value.length <= 2) {
                      context.read<CreateProfileBloc>().add(
                        FriendsShipChanged(friendship: value),
                      );
                    } else {
                      // Show warning when limit is exceeded
                      snackBarMessage(
                        context,
                        EnumLocale.selectLimit.name.tr,
                        Theme.of(context),
                      );
                    }
                  },
                  itemCount:
                      AppStrings.categorizedUserInterests["Friendship"]!.length,
                  itemBuilder: (state, i) {
                    final item =
                        AppStrings.categorizedUserInterests["Friendship"]![i];
                    final selected = state.selected(item);
                    final isLimitReached = state.value.length >= 2 && !selected;

                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: selected,
                      onChanged:
                          isLimitReached
                              ? null // disables unselected items if limit reached
                              : state.onSelected(item),
                      title: ChoiceText(
                        style: Theme.of(context).textTheme.bodyMedium,
                        highlightColor: AppColors.floralWhite,
                        item,
                        highlight: state.search?.value,
                      ),
                    );
                  },

                  modalHeaderBuilder: ChoiceModal.createHeader(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocale.chooseOption.name.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                            ),
                          ),

                          IconButton(
                            onPressed: () => Get.back(),

                            icon: Icon(
                              state.friendship.isNotEmpty
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleXmark,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  promptDelegate: ChoicePrompt.delegateBottomSheet(
                    backgroundColor: AppColors.floralWhite,
                    maxHeightFactor: 0.5,

                    /// Override tileBuilder to hide trailing icon and label
                  ),

                  anchorBuilder: (state, openModal) {
                    return InkWell(
                      onTap: openModal,
                      child: SizedBox(
                        height: 70.h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              (state.value.isEmpty)
                                  ? EnumLocale
                                      .chooseOption
                                      .name
                                      .tr // empty text = no placeholder
                                  : state.value.join(
                                    ', ',
                                  ), // or use .label if single select
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//----------------Friendship text-----------------------
class FriendshipText extends StatelessWidget {
  const FriendshipText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.friendshipInterests.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//-------------------------Title text----------------------------------
class InterestTitle extends StatelessWidget {
  const InterestTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.interestTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
    );
  }
}

//-------------------Love inlineChoice---------------------------
class LoveInchoice extends StatelessWidget {
  const LoveInchoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return Card(
          color: AppColors.floralWhite,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),

          child: Center(
            child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Choice<String>.prompt(
                  multiple: true,
                  value: state.love,
                  onChanged: (value) {
                    if (value.length <= 2) {
                      context.read<CreateProfileBloc>().add(
                        LoveChanged(love: value),
                      );
                    } else {
                      // Show warning when limit is exceeded
                      snackBarMessage(
                        context,
                        EnumLocale.selectLimit.name.tr,
                        Theme.of(context),
                      );
                    }
                  },
                  itemCount:
                      AppStrings
                          .categorizedUserInterests["Love & Romance"]!
                          .length,
                  itemBuilder: (state, i) {
                    final item =
                        AppStrings
                            .categorizedUserInterests["Love & Romance"]![i];
                    final selected = state.selected(item);
                    final isLimitReached = state.value.length >= 2 && !selected;

                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: selected,
                      onChanged:
                          isLimitReached
                              ? null // disables unselected items if limit reached
                              : state.onSelected(item),
                      title: ChoiceText(
                        style: Theme.of(context).textTheme.bodyMedium,
                        highlightColor: AppColors.floralWhite,
                        item,
                        highlight: state.search?.value,
                      ),
                    );
                  },

                  modalHeaderBuilder: ChoiceModal.createHeader(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocale.chooseOption.name.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                            ),
                          ),

                          IconButton(
                            onPressed: () => Get.back(),

                            icon: Icon(
                              state.love.isNotEmpty
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleXmark,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  promptDelegate: ChoicePrompt.delegateBottomSheet(
                    backgroundColor: AppColors.floralWhite,
                    maxHeightFactor: 0.5,

                    /// Override tileBuilder to hide trailing icon and label
                  ),

                  anchorBuilder: (state, openModal) {
                    return InkWell(
                      onTap: openModal,
                      child: SizedBox(
                        height: 70.h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              (state.value.isEmpty)
                                  ? EnumLocale
                                      .chooseOption
                                      .name
                                      .tr // empty text = no placeholder
                                  : state.value.join(
                                    ', ',
                                  ), // or use .label if single select
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//----------------Love text-----------------------
class LoveText extends StatelessWidget {
  const LoveText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.loveAndRomanceInterests.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//-------------------Sports inlineChoice---------------------------
class SportsInchoice extends StatelessWidget {
  const SportsInchoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return Card(
          color: AppColors.floralWhite,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),

          child: Center(
            child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Choice<String>.prompt(
                  multiple: true,
                  value: state.sports,
                  onChanged: (value) {
                    if (value.length <= 2) {
                      context.read<CreateProfileBloc>().add(
                        SportChanged(sports: value),
                      );
                    } else {
                      // Show warning when limit is exceeded
                      snackBarMessage(
                        context,
                        EnumLocale.selectLimit.name.tr,
                        Theme.of(context),
                      );
                    }
                  },
                  itemCount:
                      AppStrings
                          .categorizedUserInterests["Sports & Outdoors"]!
                          .length,
                  itemBuilder: (state, i) {
                    final item =
                        AppStrings
                            .categorizedUserInterests["Sports & Outdoors"]![i];
                    final selected = state.selected(item);
                    final isLimitReached = state.value.length >= 2 && !selected;

                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: selected,
                      onChanged:
                          isLimitReached
                              ? null // disables unselected items if limit reached
                              : state.onSelected(item),
                      title: ChoiceText(
                        style: Theme.of(context).textTheme.bodyMedium,
                        highlightColor: AppColors.floralWhite,
                        item,
                        highlight: state.search?.value,
                      ),
                    );
                  },

                  modalHeaderBuilder: ChoiceModal.createHeader(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocale.chooseOption.name.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                            ),
                          ),

                          IconButton(
                            onPressed: () => Get.back(),

                            icon: Icon(
                              state.sports.isNotEmpty
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleXmark,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  promptDelegate: ChoicePrompt.delegateBottomSheet(
                    backgroundColor: AppColors.floralWhite,
                    maxHeightFactor: 0.5,

                    /// Override tileBuilder to hide trailing icon and label
                  ),

                  anchorBuilder: (state, openModal) {
                    return InkWell(
                      onTap: openModal,
                      child: SizedBox(
                        height: 70.h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              (state.value.isEmpty)
                                  ? EnumLocale
                                      .chooseOption
                                      .name
                                      .tr // empty text = no placeholder
                                  : state.value.join(
                                    ', ',
                                  ), // or use .label if single select
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//----------------Sports text-----------------------
class SportsText extends StatelessWidget {
  const SportsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.sportsAndOutdoorsInterests.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//-------------------Food inlineChoice---------------------------
class FoodInchoice extends StatelessWidget {
  const FoodInchoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return Card(
          color: AppColors.floralWhite,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),

          child: Center(
            child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Choice<String>.prompt(
                  multiple: true,
                  value: state.food,
                  onChanged: (value) {
                    if (value.length <= 2) {
                      context.read<CreateProfileBloc>().add(
                        FoodChanged(food: value),
                      );
                    } else {
                      // Show warning when limit is exceeded
                      snackBarMessage(
                        context,
                        EnumLocale.selectLimit.name.tr,
                        Theme.of(context),
                      );
                    }
                  },
                  itemCount:
                      AppStrings
                          .categorizedUserInterests["Food & Restaurants"]!
                          .length,
                  itemBuilder: (state, i) {
                    final item =
                        AppStrings
                            .categorizedUserInterests["Food & Restaurants"]![i];
                    final selected = state.selected(item);
                    final isLimitReached = state.value.length >= 2 && !selected;

                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: selected,
                      onChanged:
                          isLimitReached
                              ? null // disables unselected items if limit reached
                              : state.onSelected(item),
                      title: ChoiceText(
                        style: Theme.of(context).textTheme.bodyMedium,
                        highlightColor: AppColors.floralWhite,
                        item,
                        highlight: state.search?.value,
                      ),
                    );
                  },

                  modalHeaderBuilder: ChoiceModal.createHeader(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocale.chooseOption.name.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                            ),
                          ),

                          IconButton(
                            onPressed: () => Get.back(),

                            icon: Icon(
                              state.food.isNotEmpty
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleXmark,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  promptDelegate: ChoicePrompt.delegateBottomSheet(
                    backgroundColor: AppColors.floralWhite,
                    maxHeightFactor: 0.5,

                    /// Override tileBuilder to hide trailing icon and label
                  ),

                  anchorBuilder: (state, openModal) {
                    return InkWell(
                      onTap: openModal,
                      child: SizedBox(
                        height: 70.h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              (state.value.isEmpty)
                                  ? EnumLocale
                                      .chooseOption
                                      .name
                                      .tr // empty text = no placeholder
                                  : state.value.join(
                                    ', ',
                                  ), // or use .label if single select
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//----------------Food text-----------------------
class FoodText extends StatelessWidget {
  const FoodText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.foodandRestaurantsInterests.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//-------------------Adventure inlineChoice---------------------------
class AdventureInchoice extends StatelessWidget {
  const AdventureInchoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return Card(
          color: AppColors.floralWhite,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),

          child: Center(
            child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
              builder: (context, state) {
                return Choice<String>.prompt(
                  multiple: true,
                  value: state.adventure,
                  onChanged: (value) {
                    if (value.length <= 2) {
                      context.read<CreateProfileBloc>().add(
                        AdventureChanged(adventure: value),
                      );
                    } else {
                      // Show warning when limit is exceeded
                      snackBarMessage(
                        context,
                        EnumLocale.selectLimit.name.tr,
                        Theme.of(context),
                      );
                    }
                  },
                  itemCount:
                      AppStrings
                          .categorizedUserInterests["Adventure & Travel"]!
                          .length,
                  itemBuilder: (state, i) {
                    final item =
                        AppStrings
                            .categorizedUserInterests["Adventure & Travel"]![i];
                    final selected = state.selected(item);
                    final isLimitReached = state.value.length >= 2 && !selected;

                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: selected,
                      onChanged:
                          isLimitReached
                              ? null // disables unselected items if limit reached
                              : state.onSelected(item),
                      title: ChoiceText(
                        style: Theme.of(context).textTheme.bodyMedium,
                        highlightColor: AppColors.floralWhite,
                        item,
                        highlight: state.search?.value,
                      ),
                    );
                  },

                  modalHeaderBuilder: ChoiceModal.createHeader(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocale.chooseOption.name.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                            ),
                          ),

                          IconButton(
                            onPressed: () => Get.back(),

                            icon: Icon(
                              state.adventure.isNotEmpty
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.circleXmark,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  promptDelegate: ChoicePrompt.delegateBottomSheet(
                    backgroundColor: AppColors.floralWhite,
                    maxHeightFactor: 0.5,

                    /// Override tileBuilder to hide trailing icon and label
                  ),

                  anchorBuilder: (state, openModal) {
                    return InkWell(
                      onTap: openModal,
                      child: SizedBox(
                        height: 70.h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              (state.value.isEmpty)
                                  ? EnumLocale
                                      .chooseOption
                                      .name
                                      .tr // empty text = no placeholder
                                  : state.value.join(
                                    ', ',
                                  ), // or use .label if single select
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//----------------Adventure text-----------------------
class AdventureText extends StatelessWidget {
  const AdventureText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.adventureAndTravelInterests.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//-----------------Next Button---------------
class InterestsNextButton extends StatelessWidget {
  InterestsNextButton({super.key});
  final AppGetStorage app = AppGetStorage();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return CommonButton(
          onPressed: () {
            if (state.friendship.isNotEmpty &&
                state.love.isNotEmpty &&
                state.sports.isNotEmpty) {
              app.setPageNumber(7);
              Get.offNamed(AppRoutes.passion);
            } else {
              snackBarMessage(
                context,
                EnumLocale.interestsRequired.name.tr,
                Theme.of(context),
              );
            }
          },
          buttonText: EnumLocale.next.name.tr,
        );
      },
    );
  }
}

//-------------------------PassionTitle text----------------------------------
class PassionTitle extends StatelessWidget {
  const PassionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.passion.name.tr,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

//------------------ Passion choice-------------------
class PassionChoice extends StatelessWidget {
  const PassionChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.floralWhite,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),

      child: Center(
        child: BlocBuilder<CreateProfileBloc, CreateProfileState>(
          builder: (context, state) {
            return Choice<String>.prompt(
              multiple: true,
              value: state.passion,
              onChanged: (value) {
                if (value.length <= 2) {
                  context.read<CreateProfileBloc>().add(
                    PassionChanged(passion: value),
                  );
                } else {
                  // Show warning when limit is exceeded
                  snackBarMessage(
                    context,
                    EnumLocale.selectLimit.name.tr,
                    Theme.of(context),
                  );
                }
              },
              itemCount: AppStrings.passion.length,
              itemBuilder: (state, i) {
                final item = AppStrings.passion[i];
                final selected = state.selected(item);
                final isLimitReached = state.value.length >= 2 && !selected;

                return CheckboxListTile(
                  activeColor: AppColors.primaryColor,
                  value: selected,
                  onChanged:
                      isLimitReached
                          ? null // disables unselected items if limit reached
                          : state.onSelected(item),
                  title: ChoiceText(
                    style: Theme.of(context).textTheme.bodyMedium,
                    highlightColor: AppColors.floralWhite,
                    item,
                    highlight: state.search?.value,
                  ),
                );
              },

              modalHeaderBuilder: ChoiceModal.createHeader(
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        EnumLocale.chooseOption.name.tr,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 19.sp,
                        ),
                      ),

                      IconButton(
                        onPressed: () => Get.back(),

                        icon: Icon(
                          state.passion.isNotEmpty
                              ? FontAwesomeIcons.solidCircleCheck
                              : FontAwesomeIcons.circleXmark,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              promptDelegate: ChoicePrompt.delegateBottomSheet(
                backgroundColor: AppColors.floralWhite,
                maxHeightFactor: 0.5,

                /// Override tileBuilder to hide trailing icon and label
              ),

              anchorBuilder: (state, openModal) {
                return InkWell(
                  onTap: openModal,
                  child: SizedBox(
                    height: 70.h,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          (state.value.isEmpty)
                              ? EnumLocale
                                  .chooseOption
                                  .name
                                  .tr // empty text = no placeholder
                              : state.value.join(
                                ', ',
                              ), // or use .label if single select
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//-----------------Next Button---------------
class PassionNextButton extends StatelessWidget {
  PassionNextButton({super.key});
  final AppGetStorage app = AppGetStorage();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return CommonButton(
          onPressed: () {
            if (state.passion.isNotEmpty &&
                state.food.isNotEmpty &&
                state.adventure.isNotEmpty) {
              app.setPageNumber(8);
              Get.offNamed(AppRoutes.discription);
            } else {
              snackBarMessage(
                context,
                EnumLocale.interestsRequired.name.tr,
                Theme.of(context),
              );
            }
          },
          buttonText: EnumLocale.next.name.tr,
        );
      },
    );
  }
}

//------------------------------------Upload Image for screen sent ---------------------------------------

// ---------------Submit Button--------------------------------------------
class SubmitButton extends StatelessWidget {
  SubmitButton({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return CommonButton(
          onPressed: () {
            if (state.imgURL.isNotEmpty) {
              context.read<CreateProfileBloc>().add(SubmitButtonClicked());
            } else {
              snackBarMessage(
                context,
                EnumLocale.uploadImageTitle.name.tr,
                Theme.of(context),
              );
            }
          },

          buttonText: EnumLocale.submit.name.tr,
        );
      },
    );
  }
}

//------------Center image logo---------------------
class UploadImageCenterLogo extends StatelessWidget {
  const UploadImageCenterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (context, state) {
        return InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            final BuildContext currentContext = context;
            final isGranted =
                Platform.isAndroid
                    ? await AppPermission.requestStoragePermission()
                    : await AppPermission.requestPhotosPermission();
            if (!currentContext.mounted) return;

            if (isGranted) {
              context.read<CreateProfileBloc>().add(PickImg());
            } else {
              snackBarMessage(
                context,
                Platform.isAndroid
                    ? EnumLocale.storagePermissionRequired.name.tr
                    : EnumLocale.photosPermissionDeniedText.name.tr,
                Theme.of(context),
              );
            }
          },
          child: Center(
            child:
                state.imgURL.isNotEmpty
                    ? Container(
                      height: 220.h,
                      width: 250.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(state.imgURL)),
                        ),
                      ),
                    )
                    : Lottie.asset(
                      AppStrings.uploadImage,
                      height: 220.h,
                      width: 330.w,
                    ),
          ),
        );
      },
    );
  }
}

//-------------Discription text----------------------
class UploadImageDiscription extends StatelessWidget {
  const UploadImageDiscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.uploadImageDiscription.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//-------------Title  text----------------------
class UploadImageTitle extends StatelessWidget {
  const UploadImageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.uploadImageTitle.name.tr,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//--------------- Discription screen componets---------------------

//----------------Text Regarding name discription--------------------------
class DiscriptionBody extends StatelessWidget {
  const DiscriptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.discriptionBody.name.tr,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

//----------------Text Regarding name Title--------------------------
class DiscriptionTitle extends StatelessWidget {
  const DiscriptionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      EnumLocale.discriptionTitle.name.tr,

      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

//------------------------Textfield for user input for discription------------------------
class TextFieldForDiscription extends StatefulWidget {
  const TextFieldForDiscription({super.key});

  @override
  State<TextFieldForDiscription> createState() =>
      _TextFieldForDiscriptionState();
}

class _TextFieldForDiscriptionState extends State<TextFieldForDiscription> {
  final discriptionController = TextEditingController();

  @override
  void dispose() {
    discriptionController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: TextFormField(
        scrollPadding: EdgeInsets.zero,
        expands: true, // Fills available vertical space
        maxLines: null, // Must be null when expands is true
        minLines: null,
        keyboardType: TextInputType.text,
        onChanged:
            (value) => context.read<CreateProfileBloc>().add(
              DiscriptionChanged(discription: value.trim()),
            ),
        cursorColor: AppColors.black,
        style: TextStyle(fontSize: 16),
        validator: AppValidator.validateDiscription,
        controller: discriptionController,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          errorMaxLines: 3,
          labelText: EnumLocale.discriptionLabelText.name.tr,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 2.w, color: AppColors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 1.w, color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 1.w, color: AppColors.blue),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 2.w, color: AppColors.red),
          ),

          border: InputBorder.none,
        ),
      ),
    );
  }
}

//------------------------Next Button ----------------------------------

class DiscriptionNextButton extends StatelessWidget {
   DiscriptionNextButton({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  final AppGetStorage app = AppGetStorage();

  @override
  Widget build(BuildContext context) {
    return  CommonButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          app.setPageNumber(9);
          Get.offNamed(AppRoutes.upload);
        }
      },
      buttonText: EnumLocale.next.name.tr,
    );
  }
}
