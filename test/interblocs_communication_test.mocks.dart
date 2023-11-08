// Mocks generated by Mockito 5.4.2 from annotations
// in flutter_reference/test/interblocs_communication_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:flutter_reference/data/repository/product_repository.dart'
    as _i3;
import 'package:flutter_reference/domain/entity/product.dart' as _i6;
import 'package:flutter_reference/domain/error/playground_error.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ProductRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockProductRepository extends _i1.Mock implements _i3.ProductRepository {
  @override
  _i4.Future<_i2.Either<_i5.PlaygroundError, List<_i6.Product>>> fetchProduct(
          {bool? fail = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchProduct,
          [],
          {#fail: fail},
        ),
        returnValue: _i4.Future<
                _i2.Either<_i5.PlaygroundError, List<_i6.Product>>>.value(
            _FakeEither_0<_i5.PlaygroundError, List<_i6.Product>>(
          this,
          Invocation.method(
            #fetchProduct,
            [],
            {#fail: fail},
          ),
        )),
        returnValueForMissingStub: _i4.Future<
                _i2.Either<_i5.PlaygroundError, List<_i6.Product>>>.value(
            _FakeEither_0<_i5.PlaygroundError, List<_i6.Product>>(
          this,
          Invocation.method(
            #fetchProduct,
            [],
            {#fail: fail},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.PlaygroundError, List<_i6.Product>>>);

  @override
  _i4.Future<_i2.Either<_i5.PlaygroundError, _i2.Unit>> saveProduct(
          _i6.Product? product) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveProduct,
          [product],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.PlaygroundError, _i2.Unit>>.value(
                _FakeEither_0<_i5.PlaygroundError, _i2.Unit>(
          this,
          Invocation.method(
            #saveProduct,
            [product],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.PlaygroundError, _i2.Unit>>.value(
                _FakeEither_0<_i5.PlaygroundError, _i2.Unit>(
          this,
          Invocation.method(
            #saveProduct,
            [product],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.PlaygroundError, _i2.Unit>>);

  @override
  void exposeMethod(
    String? name,
    dynamic Function(dynamic)? handler,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #exposeMethod,
          [
            name,
            handler,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<dynamic> callNativeMethod(
    String? methodName, [
    dynamic arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #callNativeMethod,
          [
            methodName,
            arguments,
          ],
        ),
        returnValue: _i4.Future<dynamic>.value(),
        returnValueForMissingStub: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
}
