<h1 align="center">Fase 1</h1>
<div align="center">
👨‍👨‍👦 Grupo 3
</div>
<div align="center">
📕 Sistemas de Bases de Datos 2
</div>
<div align="center"> 🏛 Universidad San Carlos de Guatemala</div>
<div align="center"> 📆 Primer Semestre 2025</div>

<br/>

### 👥 **Integrantes del Grupo:**

| Nombre                              | Carné       |
|------------------------------------|-------------|
| 🧑‍💼 **Jose Andres Hinestroza Garcia** | `202100316` |
| 🧑‍💼 **Joab Israel Ajsivinac Ajsivinac** | `202200135` |

## 1. Introducción  
Este documento detalla el proceso de extracción, transformación y carga (ETL) de los datos obtenidos del dataset [Basketball Dataset](https://www.kaggle.com/datasets/wyattowalsh/basketball) hacia un modelo relacional en Oracle. Se incluyen los scripts SQL utilizados, el modelo de datos, stored procedures y consultas realizadas.  

## 2. Modelo de Datos  
Se diseñó un modelo relacional normalizado que asegura la integridad y consistencia de los datos.  

### 2.1 Diagrama Entidad-Relación  
_Se adjunta el diagrama ER del modelo utilizado._  

![Diagrama ER](img/Logical.jpg)  

### 2.2 Justificación del Modelo  
- **Normalización**: Se aplicaron principios de normalización para evitar redundancias y mejorar la eficiencia de consultas.  
- **Integridad referencial**: Se definieron claves foráneas para asegurar la coherencia entre las tablas.  
- **Optimización de consultas**: Se agregaron índices en los campos más consultados.  


## 3. Carga de Datos  
Los datos fueron insertados en las tablas normalizadas.  



## 4. Stored Procedure  
Se implementó un procedimiento almacenado que permite consultar información de jugadores y equipos.  

```sql
CREATE OR REPLACE PROCEDURE get_player_or_team (
    p_name IN VARCHAR2
) AS 
BEGIN
    -- Lógica de consulta
END;
/
```

## 5. Justificación de Cambios  
### Cambio realizado
#### Justificación
#### Evidencia

---

## 6. Pruebas y Validaciones  
Se realizaron pruebas de inserción, consulta y rendimiento.  

### 6.1 Prueba de Carga  


### 6.2 Prueba de Consultas  
| Consulta | Resultado Esperado | Resultado Obtenido |
|----------|------------------|------------------|
| `SELECT * FROM Players WHERE first_name = 'LeBron';` | Datos de LeBron James | ✅ Correcto |
