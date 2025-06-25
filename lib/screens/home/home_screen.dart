import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/recipe_model.dart';
import '../auth/login_screen.dart';
import 'add_recipe_screen.dart';
import '../../widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  _loadRecipes() async {
    try {
      final recipes = await _databaseService.getRecipes();
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Recipes'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async => _loadRecipes(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        recipe: _recipes[index],
                        onDelete: () => _deleteRecipe(_recipes[index].id!),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No recipes yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first recipe',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _addRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipeScreen()),
    );

    if (result == true) {
      _loadRecipes();
    }
  }

  _deleteRecipe(String id) async {
    try {
      await _databaseService.deleteRecipe(id);
      _loadRecipes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipe: $e')),
      );
    }
  }

  _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
