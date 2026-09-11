# Prueba técnica BBDD - SQL Server

## Contenido
- `EmpresaDB.sql`: script completo de creación, datos, consultas, procedimiento, función, índice y bonus de API.
- La solución sigue el enunciado de la prueba técnica y deja un departamento sin empleados para demostrar la consulta solicitada.

## Ejecución
1. Abrir SQL Server Management Studio.
2. Ejecutar `EmpresaDB.sql`.
3. Para el bonus de API, revisar primero la sección de seguridad/OLE Automation del script.
4. El backup/restore se deja documentado con ejemplos para adaptar la ruta al servidor.

## Decisiones
- Claves primarias clustered.
- Restricciones `UNIQUE`, `CHECK` y foreign keys.
- Relación N:M mediante `EmpleadoProyecto`.
- `LEFT JOIN` para detectar proyectos/departamentos sin asignaciones.
- Índice no clustered sobre `Empleados.Apellido`.
