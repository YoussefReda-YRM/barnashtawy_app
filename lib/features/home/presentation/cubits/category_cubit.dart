import 'package:barnasht_app/features/home/domain/repos/category_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required this.categoryRepo}) : super(CategoryInitial());

  final CategoryRepo categoryRepo;

  Future<void> getCategories() async {
    emit(CategoryLoading());

    final result = await categoryRepo.getCategories();

    result.fold(
      (failure) {
        emit(CategoryFailure(errorMessage: failure.message));
      },
      (categories) {
        emit(CategorySuccess(categories: categories));
      },
    );
  }
}
