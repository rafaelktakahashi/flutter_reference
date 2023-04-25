import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/icon_with_label.dart';
import 'package:flutter_reference/view/templates/fullscreen_message.dart';
import 'package:flutter_reference/view/templates/three_state_result.dart';

class ProductResultPage extends StatelessWidget {
  const ProductResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      builder: (context, state) {
        return ThreeStateResultTemplate(
          whenLoading: const FullscreenMessageTemplate(
            centerWidget: IconWithLabel(
              icon: Icon(Icons.hourglass_bottom, color: Color(0xff919191)),
              text: "Submitting...",
            ),
            backgroundColor: Color(0xfffffea6),
          ),
          whenError: const FullscreenMessageTemplate(
            centerWidget: IconWithLabel(
              icon: Icon(Icons.error, color: Color(0xffdb0000)),
              text: "Something went wrong",
            ),
            backgroundColor: Color(0xffff8a8a),
          ),
          whenSuccess: const FullscreenMessageTemplate(
            centerWidget: IconWithLabel(
              icon: Icon(Icons.check_circle, color: Color(0xff21a600)),
              text: "Produced added!",
            ),
            backgroundColor: Color(0xffa9ebaf),
          ),
          state: state is ProductFormStateError
              ? -1
              : state is ProductFormStateSuccess
                  ? 1
                  : 0,
        );
      },
    );
  }
}
