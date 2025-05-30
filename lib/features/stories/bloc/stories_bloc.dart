import 'package:afriqueen/features/stories/bloc/stories_event.dart';
import 'package:afriqueen/features/stories/bloc/stories_state.dart';
import 'package:afriqueen/features/stories/model/stories_model.dart';
import 'package:afriqueen/features/stories/repository/stories_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final StoriesRepository _storiesRepository;
  StoriesModel _model = StoriesModel.empty;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StoriesBloc({required StoriesRepository repo})
    : _storiesRepository = repo,
      super(StoriesInitial()) {
    on<StoriesImage>((StoriesImage event, Emitter<StoriesState> emit) async {
      final id = await _auth.currentUser!.uid;
      final image = await _storiesRepository.addStoriesImageToCloudinary();
      if (image != null) {
        _model = _model.copyWith(uid: id);
        _model = _model.copyWith(containUrl: image);

        await _storiesRepository.uploadStoriesToFirebase(_model);
      }
    });

    on<StoriesVideo>((StoriesVideo event, Emitter<StoriesState> emit) async {
      final id = await _auth.currentUser!.uid;
      final video = await _storiesRepository.addStoriesVideoToCloudinary();
      if (video != null) {
        _model = _model.copyWith(uid: id);
        _model = _model.copyWith(containUrl: video);

        await _storiesRepository.uploadStoriesToFirebase(_model);
      }
    });
  }
}
