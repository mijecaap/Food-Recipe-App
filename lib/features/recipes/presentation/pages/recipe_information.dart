import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/recipes/presentation/pages/recipe_form.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_state.dart';
import 'package:recipez/core/constants/app_color.dart';

const List<Widget> textReport = <Widget>[
  Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text("Receta inapropiada")),
  Padding(padding: EdgeInsets.only(left: 16, right: 16), child: Text("Spam")),
  Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text("Receta peligrosa"))
];

enum Menu { edit, report }

class RecipeInformation extends StatefulWidget {
  final String id;
  final String userId;
  final bool edit;

  const RecipeInformation(this.id, this.userId, this.edit, {super.key});

  @override
  State<RecipeInformation> createState() => _RecipeInformationState();
}

class _RecipeInformationState extends State<RecipeInformation> {
  final List<bool> _selectReport = <bool>[true, false, false];

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(GetRecipeByIdEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is RecipeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          if (state.message.contains('eliminada')) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        if (state is RecipeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is SingleRecipeLoaded) {
          final recipe = state.recipe;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    if (widget.edit)
                      PopupMenuButton<Menu>(
                        onSelected: (Menu item) {
                          if (item == Menu.edit) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeForm(
                                  userId: widget.userId,
                                  id: recipe.id,
                                  photoURL: recipe.imageUrl,
                                  title: recipe.title,
                                  description: recipe.description,
                                  person: recipe.portions.toString(),
                                  estimatedTime:
                                      recipe.preparationTime.toString(),
                                  ingredients: recipe.ingredients,
                                  steps: recipe.steps,
                                ),
                              ),
                            );
                          } else if (item == Menu.report) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    '¿Estás seguro de eliminar esta receta?'),
                                content: const Text(
                                    'Esta acción no se puede deshacer'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<RecipeBloc>().add(
                                            DeleteRecipeEvent(recipe.id),
                                          );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                          const PopupMenuItem<Menu>(
                            value: Menu.edit,
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem<Menu>(
                            value: Menu.report,
                            child: Text('Eliminar'),
                          ),
                        ],
                      )
                    else
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    height: 300,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text(
                                            'Reportar receta',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ToggleButtons(
                                          direction: Axis.vertical,
                                          onPressed: (int index) {
                                            setState(() {
                                              for (int i = 0;
                                                  i < _selectReport.length;
                                                  i++) {
                                                _selectReport[i] = i == index;
                                              }
                                            });
                                          },
                                          selectedBorderColor:
                                              AppColor.lila_1_8ff,
                                          selectedColor: Colors.white,
                                          fillColor: AppColor.lila_1_8ff,
                                          color: Colors.black,
                                          isSelected: _selectReport,
                                          children: textReport,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.lila_1_8ff,
                                            fixedSize: const Size(200, 50),
                                          ),
                                          onPressed: () {
                                            final authState =
                                                context.read<AuthBloc>().state;
                                            if (authState is Authenticated) {
                                              final reason = _selectReport[0]
                                                  ? "Receta inapropiada"
                                                  : _selectReport[1]
                                                      ? "Spam"
                                                      : "Receta peligrosa";
                                              context.read<RecipeBloc>().add(
                                                    ReportRecipeEvent(
                                                      recipeId: recipe.id,
                                                      userId:
                                                          authState.user.uid,
                                                      reason: reason,
                                                    ),
                                                  );
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Enviar reporte'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(recipe.userPhotoUrl),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                recipe.userName,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.timer),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${recipe.preparationTime} min',
                                    style: GoogleFonts.roboto(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.people),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${recipe.portions} personas',
                                    style: GoogleFonts.roboto(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.sentiment_satisfied),
                                  const SizedBox(height: 5),
                                  Text(
                                    recipe.difficulty == 1
                                        ? 'Fácil'
                                        : recipe.difficulty == 2
                                            ? 'Medio'
                                            : 'Difícil',
                                    style: GoogleFonts.roboto(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Descripción',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            recipe.description,
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Ingredientes',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recipe.ingredients.length,
                            itemBuilder: (context, index) {
                              final ingredient = recipe.ingredients[index];
                              return ListTile(
                                leading: const Icon(Icons.arrow_right),
                                title: Text(
                                  '${ingredient['value']} ${ingredient['dimension']} de ${ingredient['name']}',
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Pasos',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recipe.steps.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColor.lila_1_8ff,
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(
                                  recipe.steps[index],
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text('Error al cargar la receta')),
        );
      },
    );
  }
}
