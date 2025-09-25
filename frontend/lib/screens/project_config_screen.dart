import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/widgets.dart';

class ProjectConfigScreen extends StatefulWidget {
  final String? token;
  const ProjectConfigScreen({super.key, this.token});

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
  late bool _isSaving = false;

  List<String> keywords = [];
  List<Map<String, dynamic>> objectivesList = [];
  List<String> criteriaList = [];

  // Estado para guardar la respuesta JSON
  Map<String, dynamic>? _savedResponse;

  void _addKeywords(String input) {
    final tokens = input
        .split(RegExp(r'[\n,;]'))
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
    setState(() => _isSaving = true);

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No has iniciado sesión")),
      );
      return;
    }

    try {
      // Mapear valores seleccionados a IDs
      int? areaId;
      switch (selectedArea) {
        case "Ciencia":
          areaId = 1;
          break;
        case "Tecnología":
          areaId = 2;
          break;
        case "Innovación":
          areaId = 3;
          break;
      }

      int? projectTypeId;
      switch (selectedType) {
        case "Divulgación":
          projectTypeId = 1;
          break;
        case "Investigación":
          projectTypeId = 2;
          break;
        case "Prototipo":
          projectTypeId = 3;
          break;
        case "Concurso":
          projectTypeId = 4;
          break;
      }

      int? participantTypeId =
          (selectedParticipants == "Grupal")
              ? 1
              : (selectedParticipants == "Individual")
              ? 2
              : null;

      int? financingTypeId;
      switch (selectedFunding) {
        case "Gobierno Federal":
          financingTypeId = 1;
          break;
        case "Gobierno Estatal":
          financingTypeId = 2;
          break;
        case "Gobierno Municipal":
          financingTypeId = 3;
          break;
        case "Iniciativa Privada":
          financingTypeId = 4;
          break;
        case "Sin financiamiento":
          financingTypeId = 5;
          break;
      }

      int? audienceTypeId;
      switch (selectedAudience) {
        case "Público general":
          audienceTypeId = 1;
          break;
        case "Sector escolar":
          audienceTypeId = 2;
          break;
        case "Autoridades gubernamentales":
          audienceTypeId = 3;
          break;
        case "Iniciativa privada":
          audienceTypeId = 4;
          break;
      }

      // Procesar objetivos
      final objectives = <Map<String, dynamic>>[];
      if (objectivesGeneralController.text.trim().isNotEmpty) {
        objectives.add({
          "type": "general",
          "description": objectivesGeneralController.text.trim(),
        });
      }
      if (objectivesSpecificController.text.trim().isNotEmpty) {
        final specificList = objectivesSpecificController.text
            .split(RegExp(r'[\n;]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty);
        for (var obj in specificList) {
          objectives.add({"type": "especifico", "description": obj});
        }
      }

      // Procesar criterios
      final criteria =
          resultsCriteriaController.text
              .split(RegExp(r'[\n;]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      // Procesar keywords
      final keywords =
          keywordsController.text
              .split(RegExp(r'[\n,;]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      
      print("📦 Keywords a enviar: $keywords");

      final amountText = fundingAmountController.text.trim();
      final amount = double.tryParse(amountText);

      if (selectedFunding != "Sin financiamiento" &&
          (amount == null || amount <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ingresa un monto válido mayor a cero")),
        );
        return;
      }

      // 1. Construir datos del perfil
      final profileData = {
        "name": "Perfil de ${titleController.text}",
        "area_id": areaId,
        "project_type_id": projectTypeId,
        "participant_type_id": participantTypeId,
        "financing_type_id": financingTypeId,
        "financing_amount": double.tryParse(fundingAmountController.text) ?? 0,
        "audience_type_id": audienceTypeId,
        "title": titleController.text,
        "wants_patent": registerPatent ? 1 : 0,
        "notes": scopeController.text,
        "objectives": objectives,
        "keywords": keywords,
        "criteria": criteria,
      };

      // 2. Crear perfil en la API
      final profileResult = await ApiService.createProfile(token, profileData);

      if (profileResult.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al crear perfil: ${profileResult['error']}"),
          ),
        );
        return;
      }

      // 3. Obtener el verdadero profile_id
      final profileId = profileResult["profile"]?["profile_id"];

      if (profileId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No se recibió profile_id")),
        );
        return;
      }

      // 4. Construir datos del proyecto usando el profile_id
      final projectData = {
        "title": titleController.text,
        "summary": justificationController.text,
        "profile_id": profileId,
        "status": "borrador",
      };

      // 5. Crear proyecto en la API
      final projectResult = await ApiService.createProject(token, projectData);

      setState(() {
        _savedResponse = projectResult; // guardamos el JSON en el estado
      });

      if (projectResult.containsKey("error")) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al crear proyecto: ${projectResult['error']}"),
          ),
        );
      } else {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Proyecto y perfil guardados correctamente"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error inesperado: $e")));
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

  Widget _buildSavedResponseView() {
    if (_savedResponse == null) return const SizedBox.shrink();

    final project = _savedResponse?["project"];
    final profile = _savedResponse?["profile"];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Datos guardados",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),

            // Proyecto
            if (project != null)
              ExpansionTile(
                title: const Text("Proyecto"),
                children: [
                  ListTile(title: Text("Título: ${project["title"]}")),
                  ListTile(title: Text("Resumen: ${project["summary"]}")),
                  ListTile(title: Text("Estado: ${project["status"]}")),
                  ListTile(title: Text("ID: ${project["project_id"]}")),
                ],
              ),

            // Perfil
            if (profile != null)
              ExpansionTile(
                title: const Text("Perfil"),
                children: [
                  ListTile(title: Text("Nombre: ${profile["name"]}")),
                  ListTile(title: Text("Título: ${profile["title"]}")),
                  ListTile(title: Text("Área: ${profile["area_id"]}")),
                  ListTile(
                    title: Text(
                      "Financiamiento: ${profile["financing_amount"]}",
                    ),
                  ),
                ],
              ),

            // Objetivos
            if (profile?["objectives"] != null)
              ExpansionTile(
                title: const Text("Objetivos"),
                children:
                    (profile["objectives"] as List)
                        .map(
                          (o) => ListTile(
                            title: Text(
                              "${o["objective_type"]}: ${o["description"]}",
                            ),
                          ),
                        )
                        .toList(),
              ),

            // Keywords
            if (profile?["keywords"] != null)
              ExpansionTile(
                title: const Text("Palabras clave"),
                children:
                    (profile["keywords"] as List)
                        .map((k) => ListTile(title: Text(k.toString())))
                        .toList(),
              ),

            // Criterios
            if (profile?["criteria"] != null)
              ExpansionTile(
                title: const Text("Criterios"),
                children:
                    (profile["criteria"] as List)
                        .map((c) => ListTile(title: Text(c.toString())))
                        .toList(),
              ),
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
                      hintText:
                          "Separa cada objetivo con comas o saltos de línea",
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
                      hintText:
                          "Separa cada criterio con comas o saltos de línea",
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
                  text: _isSaving ? "" : "Guardar proyecto",
                  onPressed: _isSaving ? () {} : _saveProject,
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Guardar proyecto"),
                ),
                const SizedBox(height: 20),
                // Mostrar el JSON bonito
                _buildSavedResponseView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
