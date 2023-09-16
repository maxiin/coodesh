import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/data/info_words_api_data_source.dart';
import 'package:coodesh/modules/info/domain/model/word.dart';
import 'package:dartz/dartz.dart';

class InfoRepository {
  final InfoWordsApiDataSource apiDataSource;

  InfoRepository(this.apiDataSource);

  Future<Either<Failure, Word>> fetchWord(String word) async {
    Either<Failure, Word> response = await apiDataSource.getWord(word);
    if(response.isRight()){
      return Right(response.getOrElse(() => Word(word: word, definitions: {}, pronunciation: '')));
    } else {
      Failure fail = response.fold((l) => l, (r) => GenericFailure(message: 'Other'));
      return Left(fail);
    }
  }
}
