// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_recipes_afame/keys.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:http/http.dart' as http;

Future<bool> startCardPayment({
  required BuildContext context,
  required String amount,
  required String currency,
  required String subscriptionId,
  required String userId,
}) async {
  Map<String, dynamic>? intentPaymentData;

  try {
    // 1. Create PaymentIntent
    Map<String, dynamic> paymentInfo = {
      "amount": amount,
      "currency": currency,
      "payment_method_types[]": "card",
    };

    http.Response response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: paymentInfo,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create PaymentIntent");
    }

    intentPaymentData = jsonDecode(response.body);
    print("Stripe PaymentIntent: $intentPaymentData");

    // 2. Initialize Payment Sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: intentPaymentData!["client_secret"],
        style: ThemeMode.system,
        merchantDisplayName: "Terru",
      ),
    );

    // 3. Present Payment Sheet
    await Stripe.instance.presentPaymentSheet();

    // 4. Hit confirmation API
    final sessionId = intentPaymentData["id"];
    final paymentType = "card";

    final confirmationUrl =
        "payment/confirm-payment"
        "?sessionId=$sessionId"
        "&paymentType=$paymentType"
        "&subscriptionId=$subscriptionId"
        "&userId=$userId"
        "&amount=$amount";

    final result = await ApiService().get(
      confirmationUrl,
    ); // fullUrl support needed

    if (result['success'] == true) {
      showCustomSnackbar("Success", "Subscription activated successfully!");
      return true;
    } else {
      showCustomSnackbar("Failed", result['message'] ?? "Confirmation failed");
    }
  } on StripeException catch (e) {
    log("StripeException: $e");
    showCustomSnackbar("Payment Cancelled", e.toString());
  } catch (e) {
    log("Error in makePayment: $e");
    showCustomSnackbar("Error", e.toString());
  }

  return false;
}
