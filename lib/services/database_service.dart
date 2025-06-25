import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await _supabase
          .from('recipes')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((recipe) => Recipe.fromJson(recipe))
          .toList();
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _supabase.from('recipes').insert({
        ...recipe.toJson(),
        'user_id': _supabase.auth.currentUser!.id,
      });
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _supabase.from('recipes').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}
