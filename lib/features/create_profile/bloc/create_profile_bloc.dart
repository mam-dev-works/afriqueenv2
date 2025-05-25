import 'package:afriqueen/features/create_profile/bloc/create_profile_event.dart';
import 'package:afriqueen/features/create_profile/bloc/create_profile_state.dart';
import 'package:afriqueen/features/create_profile/model/profile_model.dart';
import 'package:afriqueen/features/create_profile/repository/profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
//------------------ Create Profile Bloc-------------------------------------
class CreateProfileBloc extends Bloc<CreateProfileEvent, CreateProfileState> {
  final ProfileRepository profileRepository;
  final box = GetStorage();
  ProfileModel profileModel = ProfileModel(
    pseudo: '',
    sex: '',
    age: 0,
    country: '',
    city: '',
    friendship: [],
    passion: [],
    createdDate: DateTime.now(),
    love: [],
    sports: [],
    food: [],
    adventure: [],
    imgURL: '',
    discription: '',
  );
  CreateProfileBloc({required ProfileRepository repository})
    : profileRepository = repository,
      super(CreateProfileInitial()) {
    //-------------For Pseudo-----------------------
    on<PseudoChanged>((
      PseudoChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      box.write('pseudo', event.pseudo);
      profileModel = profileModel.copyWith(pseudo: event.pseudo);
    });
    //-------------------------- For Gender-----------------------------
    on<GenderChanged>((
      GenderChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(gender: event.gender));

      box.write('sex', event.gender);
      profileModel = profileModel.copyWith(sex: event.gender);
    });

    //-------------------------- For Age-----------------------------
    on<DobChanged>((DobChanged event, Emitter<CreateProfileState> emit) async {
      //debugPrint("${DateTime.now().year - value.year}");
      emit(state.copyWith(dob: event.dob));

      box.write('age', DateTime.now().year - event.dob.year);
      profileModel = profileModel.copyWith(
        age: DateTime.now().year - event.dob.year,
      );
    });

    //-------------For Address-----------------------
    on<AddressChanged>((
      AddressChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      box.write('country', event.country);
      profileModel = profileModel.copyWith(country: event.country);
      box.write('city', event.city);
      profileModel = profileModel.copyWith(city: event.city);
    });

    //-----------User Friendship-----------------------
    on<FriendsShipChanged>((
      FriendsShipChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(friendship: event.friendship));
      box.write('friendship', event.friendship);
      profileModel = profileModel.copyWith(friendship: event.friendship);
      debugPrint("Interest value :${event.friendship}");
    });

    //-----------User Passion-----------------------
    on<PassionChanged>((
      PassionChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(passion: event.passion));
      box.write('passion', event.passion);
      profileModel = profileModel.copyWith(passion: event.passion);
    });
    //-----------User Love-----------------------
    on<LoveChanged>((
      LoveChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(love: event.love));
      box.write('love', event.love);
      profileModel = profileModel.copyWith(love: event.love);
    });
    //-----------User Sports-----------------------
    on<SportChanged>((
      SportChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(sports: event.sports));
      box.write('sports', event.sports);
      profileModel = profileModel.copyWith(sports: event.sports);
    });
    //-----------User Food-----------------------
    on<FoodChanged>((
      FoodChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(food: event.food));
      box.write('food', event.food);
      profileModel = profileModel.copyWith(food: event.food);
    });

    //-----------User Adventure-----------------------
    on<AdventureChanged>((
      AdventureChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(adventure: event.adventure));
      box.write('adventure', event.adventure);
      profileModel = profileModel.copyWith(adventure: event.adventure);
    });
// ---------------For user Image----------------------
    on<PickImg>((PickImg event, Emitter<CreateProfileState> emit) async {
      final path = await repository.imagePicker();
      // ------------------user picked image path-------------------
      if (path != null) return emit(state.copyWith(imgURL: path));
    });

    //-----------User Discription-----------------------
    on<DiscriptionChanged>((
      DiscriptionChanged event,
      Emitter<CreateProfileState> emit,
    ) async {
      emit(state.copyWith(discription: event.discription));
      box.write('discription', event.discription);
      profileModel = profileModel.copyWith(discription: event.discription);
    });
//------------------------user submit data -------------------------------------
    on<SubmitButtonClicked>((
      SubmitButtonClicked event,
      Emitter<CreateProfileState> emit,
    ) async {
      try {
        emit(Loading.fromState(state));
        final secureUrl = await repository.uploadToCloudinary(state.imgURL);
        if (secureUrl != null) {
          box.write('imgURL', secureUrl);
          profileModel = profileModel.copyWith(imgURL: secureUrl);
          await repository.uploadToFirebase(profileModel);
          emit(Success.fromState(state));
        }
      } catch (e) {
        emit(Error.fromState(state, errorMessage: e.toString()));
      }
    });
  }
}
