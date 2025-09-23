-- Obtener perfil con objetivos y keywords:

SELECT p.*, a.name AS area, pt.name AS project_type
FROM profiles p
LEFT JOIN areas a ON p.area_id = a.id
LEFT JOIN project_types pt ON p.project_type_id = pt.id
WHERE p.id = 1;

SELECT * FROM profile_objectives WHERE profile_id = 1;
SELECT * FROM profile_keywords WHERE profile_id = 1;


-- Buscar proyectos relacionados por keyword (usando fulltext en keywords o join):

SELECT DISTINCT pr.*
FROM projects pr
JOIN profiles pf ON pr.profile_id = pf.id
JOIN profile_keywords kw ON kw.profile_id = pf.id
WHERE MATCH(kw.keyword) AGAINST('+robótica' IN BOOLEAN MODE);


-- Usuarios con número de perfiles:

SELECT u.id, u.email, COUNT(p.id) AS num_profiles
FROM users u
LEFT JOIN profiles p ON p.user_id = u.id
GROUP BY u.id;
