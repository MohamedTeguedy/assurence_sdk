import '../../domain/entities/duree_entity.dart';
import '../services/duree_service.dart';

class DureeRepository {
  final DureeService service = DureeService();

  Future<DureeEntity> getDurees({
    required String keyEntreprise,
    required String usage,
    required int nbrePlace,
    required int nbrePuissance,
  }) async {
    try {
      final response = await service.fetchDurees(
        keyEntreprise: keyEntreprise,
        usage: usage,
        nbrePlace: nbrePlace,
        nbrePuissance: nbrePuissance,
      );

      return DureeEntity(durees: List<int>.from(response['duree']));
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }
}
