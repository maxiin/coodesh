import 'dart:io';
import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/data/info_words_api_data_source.dart';
import 'package:coodesh/shared/model/word.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('InfoWordsApiDataSource', () {
    late InfoWordsApiDataSource dataSource;
    late MockClient mockClient;

    setUp(() async {
      mockClient = MockClient();
      dataSource = InfoWordsApiDataSource(mockClient);
      registerFallbackValue(Uri());
      await dotenv.load(fileName: ".env");
    });

    test('getWord returns a Word on successful HTTP response', () async {
      

      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response("{\"word\":\"flutter\",\"results\":[{\"definition\":\"themotionmadebyflappingupanddown\",\"partOfSpeech\":\"noun\",\"synonyms\":[\"flap\",\"flapping\",\"fluttering\"],\"typeOf\":[\"undulation\",\"wave\"]},{\"definition\":\"winkbriefly\",\"partOfSpeech\":\"verb\",\"synonyms\":[\"bat\"],\"typeOf\":[\"wink\",\"nictate\",\"nictitate\",\"blink\"]},{\"definition\":\"adisorderlyoutburstortumult\",\"partOfSpeech\":\"noun\",\"synonyms\":[\"commotion\",\"disruption\",\"disturbance\",\"hoo-ha\",\"hoo-hah\",\"hurlyburly\",\"kerfuffle\",\"to-do\"],\"typeOf\":[\"disorder\"],\"hasTypes\":[\"earthquake\",\"garboil\",\"incident\",\"convulsion\",\"uproar\",\"splash\",\"stir\",\"storm\",\"stormcenter\",\"stormcentre\",\"tempest\",\"tumultuousness\",\"tumult\",\"turmoil\",\"upheaval\"]},{\"definition\":\"movebackandforthveryrapidly\",\"partOfSpeech\":\"verb\",\"synonyms\":[\"flicker\",\"flitter\",\"quiver\",\"waver\"],\"typeOf\":[\"movebackandforth\"],\"derivation\":[\"fluttering\"]},{\"definition\":\"beatrapidly\",\"partOfSpeech\":\"verb\",\"synonyms\":[\"palpitate\"],\"typeOf\":[\"beat\",\"thump\",\"pound\"],\"verbGroup\":[\"palpitate\"]},{\"definition\":\"movealongrapidlyandlightly;skimordart\",\"partOfSpeech\":\"verb\",\"synonyms\":[\"dart\",\"fleet\",\"flit\"],\"typeOf\":[\"zip\",\"hurry\",\"speed\",\"travelrapidly\"],\"hasTypes\":[\"butterfly\"]},{\"definition\":\"theactofmovingbackandforth\",\"partOfSpeech\":\"noun\",\"synonyms\":[\"flicker\",\"waver\"],\"typeOf\":[\"move\",\"motility\",\"movement\",\"motion\"]},{\"definition\":\"abnormallyrapidbeatingoftheauriclesoftheheart(especiallyinaregularrhythm);canresultinheartblock\",\"partOfSpeech\":\"noun\",\"typeOf\":[\"arrhythmia\",\"cardiacarrhythmia\"]},{\"definition\":\"flapthewingsrapidlyorflywithflappingmovements\",\"partOfSpeech\":\"verb\",\"typeOf\":[\"flap\",\"beat\"],\"examples\":[\"Theseagullsflutteredoverhead\"]}],\"syllables\":{\"count\":2,\"list\":[\"flut\",\"ter\"]},\"pronunciation\":{\"all\":\"'test\"},\"frequency\":3.06}", 200));

      final result = await dataSource.getWord('flutter');

      result.fold((l) => print(l.message), (r) => r.word);

      expect(result, isA<Right<Failure, Word>>());
      expect(result.fold((l) => null, (r) => r.word), 'flutter');
    });

    test('getWord returns a Left(ApiFailure) on non-200 HTTP response', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Error', 404));

      final result = await dataSource.getWord('flutter');

      print(result.getOrElse(() => Word(word: 'xx', definitions: {}, pronunciation: 'xx')).word);

      expect(result, isA<Left<Failure, Word>>());
      expect(result.fold((l) => l, (r) => null), isA<Failure>());
    });

    test('getWord returns a Left(ApiFailure) on socket exception', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(const SocketException('No internet connection'));

      final result = await dataSource.getWord('flutter');

      expect(result, isA<Left<Failure, Word>>());
      expect(result.fold((l) => l, (r) => null), isA<ApiFailure>());
    });

    test('getWord returns a Left(GenericFailure) on other exceptions', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception('Some unexpected error'));

      final result = await dataSource.getWord('flutter');

      expect(result, isA<Left<Failure, Word>>());
      expect(result.fold((l) => l, (r) => null), isA<GenericFailure>());
    });
  });
}
