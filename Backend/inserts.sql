INSERT INTO areas (name) VALUES
('Ciencia'), ('Tecnología'), ('Innovación');

INSERT INTO project_types (name) VALUES
('Divulgación'), ('Investigación'), ('Prototipo'), ('Concurso');

INSERT INTO participant_types (name) VALUES
('Grupal'), ('Individual');

INSERT INTO financing_types (name) VALUES
('Gobierno Federal'), ('Gobierno Estatal'), ('Gobierno Municipal'), ('Iniciativa Privada'), ('Sin financiamiento');

INSERT INTO audience_types (name) VALUES
('Público General'), ('Sector Escolar'), ('Autoridades Gubernamentales'), ('Iniciativa Privada');

-- crear usuario (ejemplo; en prod password hashed)
INSERT INTO users (email, password_hash, name) VALUES ('prueba@ejemplo.com', 'hash_demo', 'Samuel');

-- crear perfil
INSERT INTO profiles (user_id, name, area_id, project_type_id, participant_type_id, financing_type_id, financing_amount, audience_type_id, title, wants_patent, notes)
VALUES (1, 'Perfil concurso escolar', 2, 4, 1, 5, 0.00, 2, 'Proyecto de Robótica Educativa', 0, 'Justificación ejemplo');

-- objetivos
INSERT INTO profile_objectives (profile_id, objective_type, description) VALUES
(1,'general','Desarrollar prototipo educativo de bajo costo'),
(1,'especifico','Diseñar la plataforma de control'),
(1,'especifico','Probar en 3 escuelas rurales');

-- keywords
INSERT INTO profile_keywords (profile_id, keyword) VALUES
(1,'robótica'), (1,'educación'), (1,'bajo costo');

-- criterios
INSERT INTO profile_criteria (profile_id, description) VALUES
(1,'Número de escuelas participantes'),
(1,'Funcionamiento estable del prototipo por 30 días');