import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/dropdown_field.dart';
import 'package:frontend/widgets/text_input_field.dart';
import 'package:frontend/widgets/multiline_input_field.dart';
import 'package:frontend/widgets/submit_button.dart';

class ProjectConfigScreen extends StatefulWidget {
  const ProjectConfigScreen({super.key});

  @override
  State<ProjectConfigScreen> createState() => _ProjectConfigScreenState();
}

class _ProjectConfigScreenState extends State<ProjectConfigScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController fundingAmountController = TextEditingController();
  final TextEditingController objectivesGeneralController =
      TextEditingController();
  final TextEditingController objectivesSpecificController =
      TextEditingController();
  final TextEditingController scopeController = TextEditingController();
  final TextEditingController justificationController = TextEditingController();
  final TextEditingController resultsCriteriaController =
      TextEditingController();
  final TextEditingController keywordsController = TextEditingController();

  String? selectedArea;
  String? selectedType;
  String? selectedParticipants;
  String? selectedFunding;
  String? selectedAudience;
  bool registerPatent = false;

  List<String> keywords = [];

  void _addKeywords(String input) {
    final tokens = input
        .split(RegExp(r'[;,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    setState(() {
      keywords.addAll(tokens);
    });
    keywordsController.clear();
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, "LoginScreen", (route) => false);
  }

  void _saveProject() async {
    final token = await ApiService.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No has iniciado sesión")),
      );
      return;
    }

    final projectData = {
      "title": titleController.text,
      "summary": justificationController.text,
      "profile_id": 1, // aquí obtienes el perfil real creado antes
      "status": "borrador",
    };

    final result = await ApiService.createProject(token, projectData);

    if (result.containsKey("msg")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Proyecto guardado: ${result['msg']}")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${result['error']}")));
    }
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...children.expand((w) => [w, const SizedBox(height: 16)]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurar Proyecto"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                // Datos generales
                _sectionCard(
                  title: "Datos generales",
                  children: [
                    DropdownField(
                      label: "Área de estudio",
                      items: ["Ciencia", "Tecnología", "Innovación"],
                      value: selectedArea,
                      onChanged: (val) => setState(() => selectedArea = val),
                    ),
                    DropdownField(
                      label: "Tipo de proyecto",
                      items: [
                        "Divulgación",
                        "Investigación",
                        "Prototipo",
                        "Concurso",
                      ],
                      value: selectedType,
                      onChanged: (val) => setState(() => selectedType = val),
                    ),
                    DropdownField(
                      label: "Participantes",
                      items: ["Grupal", "Individual"],
                      value: selectedParticipants,
                      onChanged:
                          (val) => setState(() => selectedParticipants = val),
                    ),
                    TextInputField(
                      label: "Título del proyecto",
                      controller: titleController,
                    ),
                  ],
                ),

                // Financiamiento
                _sectionCard(
                  title: "Financiamiento",
                  children: [
                    DropdownField(
                      label: "Fuente de financiamiento",
                      items: [
                        "Gobierno Federal",
                        "Gobierno Estatal",
                        "Gobierno Municipal",
                        "Iniciativa Privada",
                        "Sin financiamiento",
                      ],
                      value: selectedFunding,
                      onChanged: (val) {
                        setState(() {
                          selectedFunding = val;
                          if (val == "Sin financiamiento") {
                            fundingAmountController.text = "0";
                          } else {
                            fundingAmountController.clear();
                          }
                        });
                      },
                    ),
                    TextInputField(
                      label: "Monto aproximado",
                      controller: fundingAmountController,
                      keyboardType: TextInputType.number,
                      enabled: selectedFunding != "Sin financiamiento",
                    ),
                    DropdownField(
                      label: "Público al que va dirigido",
                      items: [
                        "Público general",
                        "Sector escolar",
                        "Autoridades gubernamentales",
                        "Iniciativa privada",
                      ],
                      value: selectedAudience,
                      onChanged:
                          (val) => setState(() => selectedAudience = val),
                    ),
                  ],
                ),

                // Palabras clave
                _sectionCard(
                  title: "Palabras clave",
                  children: [
                    TextField(
                      controller: keywordsController,
                      decoration: const InputDecoration(
                        labelText: "Escribe palabras clave",
                        hintText: "Ejemplo: IA, robótica; nanotecnología",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.key),
                      ),
                      onSubmitted: _addKeywords,
                    ),
                    Wrap(
                      spacing: 8,
                      children:
                          keywords
                              .map(
                                (word) => Chip(
                                  label: Text(word),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted:
                                      () =>
                                          setState(() => keywords.remove(word)),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),

                // Objetivos
                _sectionCard(
                  title: "Objetivos y Alcance",
                  children: [
                    MultilineInputField(
                      label: "Objetivo general",
                      controller: objectivesGeneralController,
                      maxLength: 500,
                    ),
                    MultilineInputField(
                      label: "Objetivos específicos",
                      controller: objectivesSpecificController,
                      maxLength: 500,
                    ),
                    MultilineInputField(
                      label: "Alcance",
                      controller: scopeController,
                      maxLength: 500,
                    ),
                    MultilineInputField(
                      label: "Justificación",
                      controller: justificationController,
                      maxLength: 500,
                    ),
                    MultilineInputField(
                      label: "Criterios para medir resultados",
                      controller: resultsCriteriaController,
                      maxLength: 500,
                    ),
                  ],
                ),

                CheckboxListTile(
                  title: const Text("¿Deseas registrar ante IMPI o Patente?"),
                  value: registerPatent,
                  onChanged:
                      (val) => setState(() => registerPatent = val ?? false),
                ),

                const SizedBox(height: 20),
                SubmitButton(
                  text: "Guardar proyecto",
                  onPressed: () {
                    _saveProject();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
