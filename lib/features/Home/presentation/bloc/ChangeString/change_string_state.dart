part of 'change_string_bloc.dart';


 class ChangeStringState extends Equatable{
  final String value;
final String image;
  const ChangeStringState({this.value="",this.image=""});
  ChangeStringState copyWith({String? value,String? image}) {
    return ChangeStringState(
      value: value ?? this.value,
      image: image ?? this.image,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [value,image];

}

class ChangeStringInitial extends ChangeStringState {

}




