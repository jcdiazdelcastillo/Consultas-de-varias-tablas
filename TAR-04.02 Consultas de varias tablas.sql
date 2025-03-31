-- CREAR TABLAS BASE DE DATOS JESUITAS

-- Crear tabla jesuita
CREATE TABLE jesuita (
    idJesuita TINYINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    codigo CHAR(5) NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    nombreAlumno VARCHAR(100) NOT NULL UNIQUE,
    firma VARCHAR(300) NOT NULL,
    firmaIngles VARCHAR(300) NOT NULL
);

-- Crear tabla lugar
CREATE TABLE lugar (
    ip CHAR(15) NOT NULL PRIMARY KEY,
    nombre_maquina CHAR(12) NOT NULL,
    lugar VARCHAR(30) NOT NULL
);

-- Crear tabla visita
CREATE TABLE visita (
    idVisita SMALLINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    idJesuita TINYINT NOT NULL,
    ip CHAR(15) NOT NULL,
    fechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Lugar_Visita FOREIGN KEY (ip) REFERENCES lugar(ip),
    CONSTRAINT FK_Jesuita_Visita FOREIGN KEY (idJesuita) REFERENCES jesuita(idJesuita)
);


-- INTRODUCIR DATOS EN LAS TABLAS

--tabla jesuita
INSERT INTO jesuita(codigo, nombre, nombreAlumno, firma, firmaIngles)VALUES
('11111','San Ignacio de Loyola', 'Juan Carlos', 'Me gusta este jesuita', 'I like this jesuit'),
('22222','San Francisco de Asis', 'Alejandro', 'Me gusta este jesuita', 'I like this jesuit'),
('33333','San Francisco Javier', 'Irene', 'Me gusta este jesuita', 'I like this jesuit');

-- tabla lugar
INSERT INTO lugar(ip, nombre_maquina, lugar)VALUES
('192.168.1.1','PC01', 'Badajoz'),
('192.168.1.2','PC02', 'Mallorca'),
('192.168.1.3','PC03', 'Vigo'),
('192.168.1.4','PC04', 'Madrid');

--tabla visitas
INSERT INTO visita(idJesuita, ip)VALUES
('4','192.168.1.1'),
('4','192.168.1.2'),
('5','192.168.1.2'),
('5','192.168.1.3'),
('6','192.168.1.4');


-- Consultas solicitadas en el ejercicio

-- 1. Muestra las visitas con el nombre del jesuita que las ha realizado
SELECT visita.idVisita, jesuita.nombre, visita.ip, visita.fechaHora
FROM visita
INNER JOIN jesuita ON visita.idJesuita = jesuita.idJesuita;

-- 2. Muestra todas las visitas con el nombre del jesuita y el lugar visitado
SELECT visita.idVisita, jesuita.nombre, lugar.lugar
FROM visita
INNER JOIN jesuita ON visita.idJesuita = jesuita.idJesuita
INNER JOIN lugar ON visita.ip = lugar.ip;

-- 3. Añade un jesuita nuevo sin visitas
INSERT INTO jesuita (codigo, nombre, nombreAlumno, firma, firmaIngles) 
VALUES ('44444', 'Pedro Arrupe', 'Lucia', 'No tiene visita', 'He don´t have visit');

-- 4. Añade 2 lugares nuevos sin visitas
INSERT INTO lugar (ip, nombre_maquina, lugar) VALUES 
('192.168.1.100', 'PCSV01', 'Barcelona'), --Les he puesto una ip y un codigo diferente para diferenciar que son los lugares que no tienen visita
('192.168.1.200', 'PCSV02', 'Granada');

-- 5. Muestra todos los jesuitas con el nombre del lugar visitado

--(LEFT JOIN) 
-- Muestra todos los jesuitas junto con el nombre del lugar que han visitado.
-- Si un jesuita no ha realizado ninguna visita, también se muestra en los resultados.
SELECT jesuita.nombre, lugar.lugar 
FROM jesuita
LEFT JOIN visita ON jesuita.idJesuita = visita.idJesuita -- Une la tabla jesuita con visita, incluyendo los jesuitas sin visitas.
LEFT JOIN lugar ON visita.ip = lugar.ip; -- Une la tabla lugar con visita, incluyendo las visitas sin lugar.

--(RIGHT JOIN)
-- Muestra todos los jesuitas junto con el nombre del lugar que han visitado.
-- Si un jesuita no ha realizado ninguna visita, también se muestra en los resultados.
-- En este caso, se usa RIGHT JOIN para priorizar la tabla `lugar`, asegurando que todos los lugares aparezcan en el resultado, incluso si no han sido visitados.
SELECT jesuita.nombre, lugar.lugar 
FROM lugar
RIGHT JOIN visita ON lugar.ip = visita.ip  -- Incluye todos los registros de `visita`, aunque no haya una coincidencia en `lugar`.
RIGHT JOIN jesuita ON visita.idJesuita = jesuita.idJesuita;  -- Incluye todos los registros de `jesuita`, aunque no haya una coincidencia en `visita`.

-- 6. Muestra todos los lugares con el nombre del jesuita que los ha visitado
SELECT lugar.lugar, jesuita.nombre 
FROM lugar
LEFT JOIN visita ON lugar.ip = visita.ip
LEFT JOIN jesuita ON visita.idJesuita = jesuita.idJesuita;

-- 7. Muestra solo los lugares que NO se han visitado
SELECT lugar.lugar
FROM lugar
LEFT JOIN visita ON lugar.ip = visita.ip
WHERE visita.idVisita IS NULL
/*¿Por qué usamos LEFT JOIN y no INNER JOIN?
   INNER JOIN no muestra los valores NULL porque solo devuelve los lugares que han sido visitados al menos una vez.
   En cambio, LEFT JOIN devuelve todos los lugares, y si un lugar no tiene visitas, los campos de la tabla "visita" se interpretan como NULL.
*/

-- 8. ------ PREGUNTAR EL MIERCOLES --------

-- 9. Muestra el nombre de los jesuitas que han realizado alguna visita
SELECT DISTINCT jesuita.nombre --Hace que solo salga una vez el jesuita aunque haya hecho muchas visitas
FROM jesuita
INNER JOIN visita ON jesuita.idJesuita = visita.idJesuita;

-- 10. Otra consulta diferente con DISTINCT
-- El DISTINCT se utiliza para asegurar que no haya lugares duplicados en el resultado.
-- Obtenemos una lista de lugares (sin duplicados) que tengan visitas.
SELECT DISTINCT lugar.lugar
FROM lugar
INNER JOIN visita ON lugar.ip = visita.ip;

-- Consultas con operadores WHERE
-- Jesuitas con nombre que empiece por 'San' USANDO LIKE
SELECT * FROM jesuita WHERE nombre LIKE 'San%';

-- LIKE - Lugares con IP que terminen en '.10'
SELECT * FROM lugar WHERE ip LIKE '%.100';

-- NOT LIKE - No mostrar los jesuitas que empiecen por San
SELECT * FROM jesuita WHERE nombre NOT LIKE 'San%';

-- Consulta con un operador de comparación negado
-- Selecciona todos los jesuitas excepto el jesuita con id 4
SELECT jesuita.nombre, visita.fechaHora 
FROM jesuita
INNER JOIN visita ON jesuita.idJesuita = visita.idJesuita
WHERE jesuita.idJesuita != 4;