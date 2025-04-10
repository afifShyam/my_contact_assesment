import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:my_contact/utils/index.dart';

part 'helper_cubit.freezed.dart';
part 'helper_state.dart';

class HelperCubit extends Cubit<HelperState> {
  HelperCubit() : super(HelperState.initial());

  void toggleFilter(ContactFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
