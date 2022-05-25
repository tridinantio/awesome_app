import 'package:awesome_app/models/photo_model.dart';
import 'package:awesome_app/services/photo_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(PhotoInitial());

  List<PhotoModel> photoList = [];
  int page = 1;

  Future<void> fetchPhotoList() async {
    try {
      emit(PhotoLoading());
      page = 1;
      photoList = await PhotoServices().fetchPhotoList(page);
      emit(PhotoSuccess(photoList));
      page++;
    } catch (e) {
      emit(PhotoFailed(e.toString()));
    }
  }

  Future<void> fetchPhotoListPagination() async {
    try {
      photoList += await PhotoServices().fetchPhotoList(page);
      emit(PhotoSuccess(photoList));
      page++;
    } catch (e) {
      emit(PhotoFailed(e.toString()));
    }
  }
}
