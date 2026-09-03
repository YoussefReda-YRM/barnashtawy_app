import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_progress_hud.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_cubit.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_state.dart';
import 'package:barnasht_app/features/add_place/presentation/views/widgets/add_place_view_body.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlaceViewBodyBlocConsumer extends StatelessWidget {
  const AddPlaceViewBodyBlocConsumer({super.key, required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPlaceCubit, AddPlaceState>(
      listener: (context, state) {
        if (state is AddPlaceValidationFailure) {
          buildBar(context, state.message, type: SnackBarType.warning);
        }

        if (state is AddPlaceFailure) {
          buildBar(context, state.message, type: SnackBarType.error);
        }

        if (state is AddPlaceSuccess) {
          FocusScope.of(context).unfocus();

          buildBar(
            context,
            'تم إرسال طلب إضافة المكان بنجاح، وسيتم مراجعته قريبًا',
            type: SnackBarType.success,
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is AddPlaceLoading,
          child: AddPlaceViewBody(category: category),
        );
      },
    );
  }
}
