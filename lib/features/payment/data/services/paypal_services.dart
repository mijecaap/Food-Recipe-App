import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  final String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  //final String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  final String clientId =
      "ASMDgrqdpHORJ_dHTBTXKpwIikd_WZn_p6EHOzPIxTxUQ6t8H07og4Y83bz3auRVdFzLk9by_Yd3U98S";
  final String secret =
      "EDWKHiec7kkU401Mv5GN1ituOx8Y1ebrQSFivUPE_uT7HJOhiJTeFYnSbBp-xGy1u_WtIb9lc8z0acOp";

  // for getting the access token from Paypal
  Future<String> getAccessToken() async {
    try {
      final client = BasicAuthClient(clientId, secret);
      final response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body["access_token"] as String;
      }
      throw Exception(
          'Failed to get access token. Status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error getting access token: $e');
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
    Map<String, dynamic> transactions,
    String accessToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$domain/v1/payments/payment'),
        body: jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        final links = body["links"] as List?;
        if (links != null && links.isNotEmpty) {
          String executeUrl = "";
          String approvalUrl = "";

          final approvalItem = links.firstWhere(
            (o) => o["rel"] == "approval_url",
            orElse: () => null,
          );

          if (approvalItem != null) {
            approvalUrl = approvalItem["href"] as String;
          }

          final executeItem = links.firstWhere(
            (o) => o["rel"] == "execute",
            orElse: () => null,
          );

          if (executeItem != null) {
            executeUrl = executeItem["href"] as String;
          }

          return {
            "executeUrl": executeUrl,
            "approvalUrl": approvalUrl,
          };
        }
        return null;
      }
      throw Exception(body["message"] ?? 'Failed to create payment');
    } catch (e) {
      throw Exception('Error creating payment: $e');
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(
      String url, String payerId, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body["id"] as String?;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body["message"] ?? 'Failed to execute payment');
    } catch (e) {
      throw Exception('Error executing payment: $e');
    }
  }
}
