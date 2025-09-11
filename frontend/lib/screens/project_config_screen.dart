import 'package:flutter/material.dart';
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
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController objectivesGeneralController = TextEditingController();
  final TextEditingController objectivesSpecificController = TextEditingController();
  final TextEditingController scopeController = TextEditingController();
  final TextEditingController justificationController = TextEditingController();
  final TextEditingController resultsCriteriaController = TextEditingController();

  String? selectedArea;
  String? selectedType;
  String? selectedParticipants;
  String? selectedFunding;
  String? selectedAudience;
  bool registerPatent = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurar Proyecto"),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Información general", theme),
            DropdownField(
              label: "Área de estudio",
              items: ["Ciencia", "Tecnología", "Innovación"],
              value: selectedArea,
              onChanged: (val) => setState(() => selectedArea = val),
            ),
            DropdownField(
              label: "Tipo de proyecto",
              items: ["Divulgación", "Investigación", "Prototipo", "Concurso"],
              value: selectedType,
              onChanged: (val) => setState(() => selectedType = val),
            ),
            DropdownField(
              label: "Participantes",
              items: ["Grupal", "Individual"],
              value: selectedParticipants,
              onChanged: (val) => setState(() => selectedParticipants = val),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Financiamiento", theme),
            DropdownField(
              label: "Fuente de financiamiento",
              items: [
                "Gobierno Federal",
                "Gobierno Estatal",
                "Gobierno Municipal",
                "Iniciativa Privada",
                "Sin financiamiento"
              ],
              value: selectedFunding,
              onChanged: (val) => setState(() => selectedFunding = val),
            ),
            TextInputField(
              label: "Monto aproximado",
              controller: fundingAmountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Detalles del proyecto", theme),
            DropdownField(
              label: "Público objetivo",
              items: [
                "Público general",
                "Sector escolar",
                "Autoridades gubernamentales",
                "Iniciativa privada"
              ],
              value: selectedAudience,
              onChanged: (val) => setState(() => selectedAudience = val),
            ),
            TextInputField(
              label: "Título del proyecto",
              controller: titleController,
            ),
            TextInputField(
              label: "Palabras clave",
              controller: keywordsController,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Redacción", theme),
            MultilineInputField(
              label: "Objetivo general",
              controller: objectivesGeneralController,
            ),
            MultilineInputField(
              label: "Objetivos específicos",
              controller: objectivesSpecificController,
            ),
            MultilineInputField(
              label: "Alcance",
              controller: scopeController,
            ),
            MultilineInputField(
              label: "Justificación",
              controller: justificationController,
            ),
            MultilineInputField(
              label: "Criterios de resultados",
              controller: resultsCriteriaController,
            ),
            const SizedBox(height: 10),

            CheckboxListTile(
              title: const Text("¿Deseas registrar ante IMPI o Patente?"),
              value: registerPatent,
              onChanged: (val) => setState(() => registerPatent = val ?? false),
              activeColor: colorScheme.primary,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),

            // Botón
            SizedBox(
              width: double.infinity,
              child: SubmitButton(
                text: "Guardar proyecto",
                onPressed: () {
                  // TODO: integrar backend
                  print("Proyecto guardado: ${titleController.text}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Proyecto '${titleController.text}' guardado"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
