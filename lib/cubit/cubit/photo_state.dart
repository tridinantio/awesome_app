part of 'photo_cubit.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoFailed extends PhotoState {
  final String errorMessage;

  PhotoFailed(this.errorMessage);

  @override
  // TODO: implement props
  List<Object> get props => [errorMessage];
}

class PhotoSuccess extends PhotoState {
  final List<PhotoModel> photoList;

  PhotoSuccess(this.photoList);

  @override
  // TODO: implement props
  List<Object> get props => [photoList];
}
