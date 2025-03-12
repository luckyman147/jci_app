
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/entities/Agenda.dart';

part 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  AgendaCubit() : super(AgendaInitial());
  void InitializeAgenda(List<Agenda> list){
    emit(state.copyWith(agendas: list));
  }

}
