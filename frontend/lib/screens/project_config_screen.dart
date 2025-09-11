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
    return Scaffold(
      appBar: AppBar(title: const Text("Configurar Proyecto")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            DropdownField(
              label: "Financiamiento",
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
              label: "Monto aproximado de financiamiento",
              controller: fundingAmountController,
              keyboardType: TextInputType.number,
            ),
            DropdownField(
              label: "Público al que va dirigido",
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
            const SizedBox(height: 10),
            Text("Palabras clave y redacción:", style: Theme.of(context).textTheme.titleMedium),
            MultilineInputField(label: "Objetivo general", controller: objectivesGeneralController),
            MultilineInputField(label: "Objetivos específicos", controller: objectivesSpecificController),
            MultilineInputField(label: "Alcance", controller: scopeController),
            MultilineInputField(label: "Justificación", controller: justificationController),
            MultilineInputField(label: "Criterios para medir resultados", controller: resultsCriteriaController),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text("¿Deseas registrar ante IMPI o Patente?"),
              value: registerPatent,
              onChanged: (val) => setState(() => registerPatent = val ?? false),
            ),
            const SizedBox(height: 20),
            SubmitButton(
              text: "Guardar proyecto",
              onPressed: () {
                // Aquí puedes mandar los datos al backend
                print("Proyecto guardado: ${titleController.text}");
              },
            )
          ],
        ),
      ),
    );
  }
}
