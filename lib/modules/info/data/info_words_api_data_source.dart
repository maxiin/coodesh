import 'dart:convert';
import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/domain/model/word.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class InfoWordsApiDataSource {
  Future<Either<Failure, Word>> getWord(String word) async {
    if (word.isEmpty) {
      return Left(ArgumentFailure(message: 'Start line must be less than or equal to end line'));
    }
    final url = Uri.parse('https://wordsapiv1.p.rapidapi.com/words/$word');
    final headers = {
      'X-RapidAPI-Key': dotenv.env['RAPIDAPI_KEY'] ?? '',
      'X-RapidAPI-Host': 'wordsapiv1.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Word.fromApiJson(data));
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return Left(ApiFailure(message: response.body, code: response.statusCode));
      }
    } catch (error) {
      return Left(GenericFailure(message: error.toString()));
    }
  }
}
