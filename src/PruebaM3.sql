CREATE DATABASE pruebaM3;

USE pruebaM3;

-- 1. Crea el modelo.
CREATE TABLE peliculas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    anno INT NOT NULL
);

CREATE TABLE tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tag VARCHAR(32) NOT NULL
);

CREATE TABLE pelicula_tag (
    id_pelicula INT NOT NULL ,
    id_tag INT NOT NULL ,
    FOREIGN key (id_pelicula) REFERENCES peliculas (id),
    FOREIGN key (id_tag) REFERENCES tags (id)
);

-- 2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados.

INSERT INTO peliculas (id, nombre, anno)
VALUES
    (1, 'Hellraiser 1', 1987),
    (2, 'Hellraiser 2', 1988),
    (3, 'Hellraiser 3', 1992),
    (4, 'Hellraiser 4', 1996),
    (5, 'Hellraiser 5', 2000);

INSERT INTO tags (id, tag)
VALUES
    (1, 'Clive Barker'),
    (2, 'Terror'),
    (3, 'Fantasia'),
    (4, 'Gore'),
    (5, 'Doug Bradley');

INSERT INTO pelicula_tag (id_pelicula, id_tag)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4);

-- 3. Cuenta la cantidad de tags que tiene cada película.
SELECT nombre AS "Pelicula",
    COUNT(tag) AS "Cantidad_tag"
FROM peliculas LEFT JOIN pelicula_tag pt ON peliculas.id = pt.id_pelicula
               LEFT JOIN tags t ON t.id = pt.id_tag
GROUP BY nombre;

-- 4. Crea las tablas.
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    edad INT NOT NULL
);

CREATE TABLE preguntas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    preguntas VARCHAR(255) NOT NULL,
    respuesta_correcta VARCHAR(255) NOT NULL
);

CREATE TABLE respuestas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    respuesta VARCHAR(255) NOT NULL,
    id_usuario INT NOT NULL,
    id_pregunta INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
    FOREIGN KEY (id_pregunta) REFERENCES preguntas(id)
);

-- 5. Agrega 5 registros a la tabla preguntas,
INSERT INTO preguntas (preguntas, respuesta_correcta)
VALUES
    ('¿Cómo se denomina el miedo excesivo al paso del tiempo?', 'cronofobia'),
    ('¿Cómo se denomina el miedo excesivo al color amarillo?', 'xantofobia'),
    ('¿Cómo se denomina el miedo excesivo a los espejos?', 'eisoptrofobia'),
    ('¿Cómo se denomina el miedo excesivo a dormir?', 'somnifobia'),
    ('¿Cómo se denomina el miedo excesivo al 666?', 'hexacosioihexakontahexafobia');
INSERT INTO usuarios (nombre, edad)
VALUES
    ('Aioria', 25),
    ('Aldebaran', 20),
    ('Shura', 23),
    ('Saga', 30),
    ('Camus', 27);
INSERT INTO respuestas
(id_usuario, id_pregunta, respuesta)
VALUES
    (1, 1, 'cronofobia'),
    (2, 1, 'cronofobia'),
    (5, 2, 'xantofobia'),
    (3, 3, 'error'),
    (4, 4, 'error'),
    (4, 5, 'error');

-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT a.nombre,
    COUNT(c.id) AS respuestas_correctas
FROM usuarios a
         INNER JOIN respuestas b ON a.id = b.id_usuario
         INNER JOIN preguntas c ON b.id_pregunta = c.id AND b.respuesta = c.respuesta_correcta
GROUP BY a.nombre;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.

SELECT c.preguntas,
    SUM(c.respuestas) AS respuesta_correcta
FROM (SELECT a.preguntas,
            CASE
                WHEN a.respuesta_correcta = b.respuesta THEN 1
                WHEN a.respuesta_correcta <> b.respuesta THEN 0
                END AS respuestas
            FROM preguntas a
              LEFT JOIN respuestas b ON a.id = b.id_pregunta) AS c
GROUP BY c.preguntas;

-- 8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.
DELETE FROM respuestas WHERE id_usuario = 1;
DELETE FROM usuarios WHERE id = 1;

-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE usuarios
    ADD CHECK (edad >= 18);

-- 10. Altera la tabla existente de usuarios agregando el campo email con la restricción de único.
ALTER TABLE usuarios
    ADD COLUMN email VARCHAR(255) UNIQUE;

