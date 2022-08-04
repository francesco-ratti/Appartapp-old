import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/tab_widget_lessor.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:appartapp/widgets/tab_widget_tenant.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  Apartment apartment = Apartment(
      id: 000,
      listingTitle: 'test title',
      description: 'test description',
      price: 500,
      address: 'test address',
      additionalExpenseDetail: 'test expenses',
      imagesDetails: [],
      images: []);

  var mapUsr = {
    'id': 000,
    "email": 'email@email.it',
    'name': 'Mario',
    'surname': 'Roca',
    'birthday': 919551600000,
    'gender': 'M',
    'images': [],
    'bio': "text",
    'reason': 'study',
    'month': 'Settembre',
    'job': 'studente',
    'income': '1600',
    'smoker': 'No',
    'pets': 'Gatto'
  };
  User usr = User.fromMap(mapUsr);

  LikeFromUser likeFromUser = LikeFromUser(apartment, usr);
  group('Tenant viewer testing for MOBILE  -->', () {
    testWidgets('Tenant viewer has a Sliding Up Panel', (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TenantViewer(
            tenantLoaded: true,
            lessor: false,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the SlidingUpPanel widgets appear exactly once in the widget tree.
      expect(find.byType(SlidingUpPanel), findsOneWidget);
    });

    testWidgets(
        'CircularProgressIndicator and TabWidgetLoading present if the teanant is not yet loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TenantViewer(
            tenantLoaded: false,
            lessor: false,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the CircularProgressIndicator and the TabWidgetLoading widgets appear exactly once in the widget tree.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TabWidgetLoading), findsOneWidget);
    });

    testWidgets(
        'TenantModel and TabWidgetLessor present if the tenant is loaded and is a lessor',
        (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          //MediaQuery required to avoid compilation error
          //MaterialApp required to set a text direction in the widget to test
          data: const MediaQueryData(),
          child: MaterialApp(
              home: TenantViewer(
            tenantLoaded: true,
            lessor: true,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ))));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the TenantModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(TenantModel), findsOneWidget);
      expect(find.byType(TabWidgetLessor), findsOneWidget);
    });

    testWidgets(
        'TenantModel and TabWidgetTenant present if the tenant is loaded and is a tenant',
        (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          //MediaQuery required to avoid compilation error
          //MaterialApp required to set a text direction in the widget to test
          data: const MediaQueryData(),
          child: MaterialApp(
              home: TenantViewer(
            tenantLoaded: true,
            lessor: false,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ))));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the TenantModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(TenantModel), findsOneWidget);
      expect(find.byType(TabWidgetTenant), findsOneWidget);
    });
  });

  group('Tenant viewer testing for TABLET  -->', () {
    testWidgets('No Sliding Up Panel', (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
            home: TenantViewer(
                tenantLoaded: true,
                lessor: true,
                currentLikeFromUser: likeFromUser,
                updateUI: (bool arg) {},
                match: true)),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the TenantModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(SlidingUpPanel), findsNothing);
    });

    testWidgets(
        'CircularProgressIndicator and TabWidgetLoading present if the tenant is not yet loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          //MediaQuery required to avoid compilation error
          //MaterialApp required to set a text direction in the widget to test
          data: const MediaQueryData(),
          child: MaterialApp(
              home: TenantViewer(
                  tenantLoaded: false,
                  lessor: true,
                  updateUI: (bool arg) {},
                  currentLikeFromUser: likeFromUser,
                  match: true))));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the CircularProgressIndicator and the TabWidgetLoading widgets appear exactly once in the widget tree.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TabWidgetLoading), findsOneWidget);
    });

    testWidgets(
        'TenantModel and TabWidgetLessor present if the tenant is loaded and is a lessor',
        (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          //MediaQuery required to avoid compilation error
          //MaterialApp required to set a text direction in the widget to test
          data: const MediaQueryData(),
          child: MaterialApp(
              home: TenantViewer(
            tenantLoaded: true,
            lessor: true,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ))));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the TenantModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(TenantModel), findsOneWidget);
      expect(find.byType(TabWidgetLessor), findsOneWidget);
    });

    testWidgets(
        'TenantModel and TabWidgetTenant present if the tenant is loaded and is a lessor',
        (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          //MediaQuery required to avoid compilation error
          //MaterialApp required to set a text direction in the widget to test
          data: const MediaQueryData(),
          child: MaterialApp(
              home: TenantViewer(
            tenantLoaded: true,
            lessor: false,
            updateUI: (bool arg) {},
            currentLikeFromUser: likeFromUser,
            match: true,
          ))));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the TenantModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(TenantModel), findsOneWidget);
      expect(find.byType(TabWidgetTenant), findsOneWidget);
    });
  });
}
