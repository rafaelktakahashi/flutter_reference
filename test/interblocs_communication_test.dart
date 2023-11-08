import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/infra/global_event.dart';
import 'package:flutter_reference/business/login_demo/bloc1.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/data/service/app_data_service.dart';
import 'package:flutter_reference/domain/entity/address.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/entity/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ProductRepository>()])
import 'interblocs_communication_test.mocks.dart';

/// In unit tests, when you need a way to simulate global events to verify that
/// your blocs correctly respond to them, you can make a mock bloc to expose
/// the `addGlobal` function present in the `GlobalEventAware` mixin.
class MockGlobalEventEmitter extends Bloc<Unit, Unit> with GlobalEventAware {
  MockGlobalEventEmitter() : super(unit);

  // Expose a way of adding an event to the global event stream.
  void mockAddGlobal(GlobalEvent event) {
    super.addGlobal(event);
  }
}

void setupDependencyInjection() {
  GetIt.I.registerSingleton<AppDataService>(AppDataService());
  GetIt.I.registerSingleton<ProductRepository>(MockProductRepository());
}

void main() {
  setUpAll(() {
    setupDependencyInjection();
  });

  late MockGlobalEventEmitter mockEventEmitter;
  late Bloc1 bloc1;

  setUp(() {
    mockEventEmitter = MockGlobalEventEmitter();
    bloc1 = Bloc1();
  });

  test('Logout clears Bloc1', () async {
    final appDataService = GetIt.I.get<AppDataService>();
    // Simulate a user who is logged in.
    appDataService.writeCurrentUser(const User(
      username: "mocker@mail.com",
      userRole: UserRole.admin,
      name: PersonNameEnglish("Edward", "Bernard", "Cliff", "Ed"),
      address: Address(
          postalCode: "60628",
          number: "1907",
          streetAddress: "S Halsted St",
          city: "Chicago",
          state: "IL",
          country: "USA"),
    ));

    // Stub the mock
    when(GetIt.I.get<ProductRepository>().fetchProduct())
        .thenAnswer((_) => Future.value(const Right([
              Product(
                id: "110",
                name: "Powder computer",
                description: "Finely ground computer.",
                amountInStock: 3,
                unit: "g",
                pricePerUnitCents: 799, // 7,99 €
              ),
              Product(
                id: "190",
                name: "Paperback",
                description:
                    "The backside of a sheet of paper (front side purchased separately).",
                amountInStock: 5,
                unit: "unit",
                pricePerUnitCents: 299,
              ),
              Product(
                id: "210",
                name: "Green ideas",
                description:
                    "Thought, concept or mental impression of the green variety.",
                amountInStock: 8,
                unit: "unit",
                pricePerUnitCents: 2599,
              ),
            ])));

    bloc1.add(const FetchProducts1Event());
    await Future.delayed(const Duration(milliseconds: 100));
    expect(bloc1.state, isA<Bloc1StateList>());
    expect((bloc1.state as Bloc1StateList).products.length > 1, true);

    // Simulate a logout event
    mockEventEmitter.mockAddGlobal(const GlobalEventLogout());

    await Future.delayed(const Duration(milliseconds: 100));
    expect(bloc1.state, isA<Bloc1StateEmpty>());
  });
}
