import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/info/domain/info_repository.dart';
import 'package:coodesh/modules/info/domain/model/word.dart';
import 'package:dartz/dartz.dart';

class InfoUseCase { 
  final InfoRepository repo;

  InfoUseCase(this.repo);

  Future<Either<Failure, Word>> call(String word){
    return repo.fetchWord(word);
  }
}