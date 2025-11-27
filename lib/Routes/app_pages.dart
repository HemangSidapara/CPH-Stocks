import 'package:cph_stocks/Screens/home_screen/account_screen/account_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/categories_screen/categories_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/categories_screen/categories_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/employees_in_month_screen/employees_in_month_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/employees_in_month_screen/employees_in_month_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/payment_details_screen/payment_details_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/payment_details_screen/payment_details_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/pending_payment_screen/pending_payment_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/pending_payment_screen/pending_payment_view.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/reports_screen/reports_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/reports_screen/reports_view.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/dashboard_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/add_order_cycle_screen/add_order_cycle_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/add_order_cycle_screen/add_order_cycle_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/order_details_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_sequence_screen/order_sequence_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_sequence_screen/order_sequence_view.dart';
import 'package:cph_stocks/Screens/home_screen/home_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/home_view.dart';
import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/parties_screen/parties_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/settings_screen/settings_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/settings_screen/settings_view.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_bindings.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_view.dart';
import 'package:cph_stocks/Screens/splash_screen/splash_bindings.dart';
import 'package:cph_stocks/Screens/splash_screen/splash_view.dart';
import 'package:cph_stocks/Screens/verify_otp_screen/verify_otp_bindings.dart';
import 'package:cph_stocks/Screens/verify_otp_screen/verify_otp_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

Duration transitionDuration = const Duration(milliseconds: 400);

class AppPages {
  static final pages = [
    ///Splash Screen
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashView(),
      binding: SplashBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///SignIn Screen
    GetPage(
      name: Routes.signInScreen,
      page: () => const SignInView(),
      binding: SignInBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Home Screen
    GetPage(
      name: Routes.homeScreen,
      page: () => const HomeView(),
      bindings: [
        HomeBindings(),
        DashboardBindings(),
        AccountBindings(),
        RecycleBinBindings(),
        NotesBindings(),
        CashFlowBindings(),
        PartiesBindings(),
        SettingsBindings(),
      ],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Settings
    GetPage(
      name: Routes.settingsScreen,
      page: () => const SettingsView(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Create Order Screen
    GetPage(
      name: Routes.createOrderScreen,
      page: () => const CreateOrderView(),
      binding: CreateOrderBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Order Details Screen
    GetPage(
      name: Routes.orderDetailsScreen,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Add Order Cycle Screen
    GetPage(
      name: Routes.addOrderCycleScreen,
      page: () => const AddOrderCycleView(),
      binding: AddOrderCycleBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///View Cycles Screen
    GetPage(
      name: Routes.viewCyclesScreen,
      page: () => const ViewCyclesView(),
      binding: ViewCyclesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Challan Screen
    GetPage(
      name: Routes.challanScreen,
      page: () => const ChallanView(),
      binding: ChallanBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Ledger Screen
    GetPage(
      name: Routes.ledgerScreen,
      page: () => const LedgerView(),
      binding: LedgerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Order Sequence Screen
    GetPage(
      name: Routes.orderSequenceScreen,
      page: () => const OrderSequenceView(),
      binding: OrderSequenceBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Payment Ledger Screen
    GetPage(
      name: Routes.paymentLedgerScreen,
      page: () => const LedgerView(isPaymentLedger: true),
      binding: LedgerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Payment Details Screen
    GetPage(
      name: Routes.paymentDetailsScreen,
      page: () => const PaymentDetailsView(),
      binding: PaymentDetailsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Pending Payment Screen
    GetPage(
      name: Routes.pendingPaymentScreen,
      page: () => const PendingPaymentView(),
      binding: PendingPaymentBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Reports Screen
    GetPage(
      name: Routes.reportsScreen,
      page: () => const ReportsView(),
      binding: ReportsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Employee In Month Screen
    GetPage(
      name: Routes.employeeInMonthScreen,
      page: () => const EmployeesInMonthView(),
      binding: EmployeesInMonthBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Categories Screen
    GetPage(
      name: Routes.categoriesScreen,
      page: () => const CategoriesView(),
      binding: CategoriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Verify OTP Screen
    GetPage(
      name: Routes.verifyOtpScreen,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
  ];
}
