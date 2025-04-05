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

### **1. Carga de Datos para `COMMON_PLAYER_INFO_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**

![Diagrama ER](img/c_player.png)  

1. Iniciamos haciendo clic derecho sobre la tabla **`COMMON_PLAYER_INFO_TEMP`** en el árbol de objetos y seleccionamos la opción **"Importar Datos..."** para abrir el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/c_player1.png)  
2. En la ventana de selección de archivos, buscamos y seleccionamos el archivo **`common_player_info.csv`** en nuestra computadora, y luego hacemos clic en **"Abrir"**.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/c_player2.png)  
3. Se muestra una vista previa del contenido del archivo CSV. En este paso, seleccionamos las columnas que deseamos importar y las asignamos a las columnas de la tabla temporal correspondiente, en este caso no se hace ningún cambio ya que todas las columnas las vamos a insertar.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/c_player4.png)  
4. En esta etapa, definimos las columnas en la tabla temporal de destino y verificamos que los tipos de datos y nombres de columnas sean correctos para asegurar la correcta importación. En este caso tenemos 2 errores por que los nombres no coinceden, para solucionarlo como se ve en la imagen sedebe seleccionar `coincidir por: Posición`

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/c_player5.png)  
5.  Finalmente, verificamos todos los pasos anteriores y hacemos clic en **"Terminar"** para ejecutar la importación de datos. Los datos del archivo CSV se insertarán en la tabla temporal **`COMMON_PLAYER_INFO_TEMP`**.

---

### **2. Carga de Datos para `DRAFT_HISTORY_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/draft.png)  
1. Se realiza el mismo procedimiento, haciendo clic derecho sobre la tabla **`DRAFT_HISTORY_TEMP`** y seleccionando **"Importar Datos..."** para abrir el asistente de importación.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/draft1.png)  
2. Seleccionamos el archivo **`draft_history.csv`** en el sistema de archivos y hacemos clic en **"Abrir"**.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/draft1.png)  
3. Aparece una vista previa del archivo CSV. Se seleccionan las columnas a importar y se asignan a las columnas correspondientes de la tabla temporal.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/draft4.png)  
4. Definimos las columnas de la tabla temporal y verificamos su correspondencia con los datos en el archivo CSV. En este caso tenemos 2 errores por que los nombres no coinceden, para solucionarlo como se ve en la imagen sedebe seleccionar `coincidir por: Posición`

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/draft5.png)  
5. Después de verificar que todas las configuraciones son correctas, seleccionamos **"Terminar"** para proceder con la carga de los datos en la tabla temporal.

---

### **3. Carga de Datos para `DRAFT_COMBINE_STATS`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/draft_c.png)  
1.  Seleccionamos la tabla **`DRAFT_COMBINE_STATS`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/draft_c1.png)  
2.    Elegimos el archivo **`draft_combine_stats.csv`** y lo abrimos para continuar con el proceso.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/draft_c2.png)  
3. Vemos una vista previa de los datos y seleccionamos las columnas correspondientes para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/draft_c3.png)  
4. Definimos y asignamos las columnas correctas para la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/draft_c4.png)  
5. Finalmente, verificamos la configuración y hacemos clic en **"Terminar"** para cargar los datos en la tabla temporal **`DRAFT_HISTORY_TEMP`**.

---

### **4. Carga de Datos para `GAME_TEMP`**
#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/game.png) 
1. Hacemos clic derecho sobre la tabla **`GAME_TEMP`** y seleccionamos **"Importar Datos..."**.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/game1.png) 
2. Seleccionamos el archivo **`game.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/game2.png) 
3. Visualizamos el archivo CSV y seleccionamos las columnas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/game4.png) 
4. Asignamos las columnas de la tabla temporal para que coincidan con las del archivo CSV.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/game5.png) 
5. Confirmamos la importación y hacemos clic en **"Terminar"** para cargar los datos en **`GAME_INFO_TEMP`**.

---

### **5. Carga de Datos para `GAME_SUMMARY_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/game_s.png)
1. Hacemos clic derecho sobre **`GAME_SUMMARY_TEMP`** y seleccionamos **"Importar Datos..."**.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/game_s1.png)
2. Elegimos el archivo **`game_summary.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/game_s2.png)
3. Se previsualizan los datos y seleccionamos las columnas a importar.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/game_s4.png)
4. Definimos las columnas de la tabla temporal para la correcta asignación de los datos.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/game_s5.png)
5.  Verificamos la configuración y hacemos clic en **"Terminar"** para completar la carga de datos en **`GAME_SUMMARY_TEMP`**.

---

### **6. Carga de Datos para `TEAM_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/team.png)
1. Seleccionamos la tabla **`TEAM_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/team1.png)
2. Seleccionamos el archivo **`team.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/team2.png)
3. Previsualizamos los datos y seleccionamos las columnas adecuadas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/team4.png)
4. Asignamos las columnas de destino en la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/team5.png)
5. Confirmamos la configuración y completamos la importación haciendo clic en **"Terminar"**.







### **7. Carga de Datos para `GAME_INFO_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**

![Diagrama ER](img/game_i.png)  

1. Iniciamos haciendo clic derecho sobre la tabla **`GAME_INFO_TEMP`** en el árbol de objetos y seleccionamos la opción **"Importar Datos..."** para abrir el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/game_i1.png)  
2. En la ventana de selección de archivos, buscamos y seleccionamos el archivo **`game_info.csv`** en nuestra computadora, y luego hacemos clic en **"Abrir"**.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/game_i2.png) 
3. Se muestra una vista previa del contenido del archivo CSV. En este paso, seleccionamos las columnas que deseamos importar y las asignamos a las columnas de la tabla temporal correspondiente, en este caso no se hace ningún cambio ya que todas las columnas las vamos a insertar.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/game_i4.png) 
4. En esta etapa, definimos las columnas en la tabla temporal de destino y verificamos que los tipos de datos y nombres de columnas sean correctos para asegurar la correcta importación. En este caso tenemos 2 errores por que los nombres no coinceden, para solucionarlo como se ve en la imagen sedebe seleccionar `coincidir por: Posición`

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/game_i5.png) 
5.  Finalmente, verificamos todos los pasos anteriores y hacemos clic en **"Terminar"** para ejecutar la importación de datos. Los datos del archivo CSV se insertarán en la tabla temporal **`GAME_INFO_TEMP`**.

---

### **8. Carga de Datos para `INACTIVE_PLAYERS_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/inactive.png)  
1. Se realiza el mismo procedimiento, haciendo clic derecho sobre la tabla **`INACTIVE_PLAYERS_TEMP`** y seleccionando **"Importar Datos..."** para abrir el asistente de importación.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/inactive1.png)  
2. Seleccionamos el archivo **`inactive_players.csv`** en el sistema de archivos y hacemos clic en **"Abrir"**.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/inactive2.png)  
3. Aparece una vista previa del archivo CSV. Se seleccionan las columnas a importar y se asignan a las columnas correspondientes de la tabla temporal.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/inactive4.png)  
4. Definimos las columnas de la tabla temporal y verificamos su correspondencia con los datos en el archivo CSV. En este caso tenemos 2 errores por que los nombres no coinceden, para solucionarlo como se ve en la imagen sedebe seleccionar `coincidir por: Posición`

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/inactive5.png)  
5. Después de verificar que todas las configuraciones son correctas, seleccionamos **"Terminar"** para proceder con la carga de los datos en la tabla temporal.

---

### **9. Carga de Datos para `LINE_SCORE_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/line.png)  
1.  Seleccionamos la tabla **`LINE_SCORE_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/line1.png)  
2.    Elegimos el archivo **`line_score.csv`** y lo abrimos para continuar con el proceso.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/line2.png)  
3. Vemos una vista previa de los datos y seleccionamos las columnas correspondientes para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/line4.png)  
4. Definimos y asignamos las columnas correctas para la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/line5.png)  
5. Finalmente, verificamos la configuración y hacemos clic en **"Terminar"** para cargar los datos en la tabla temporal **`LINE_SCORE_TEMP`**.

---

### **10. Carga de Datos para `OFFICIALS_TEMP`**
#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/official.png) 
1. Hacemos clic derecho sobre la tabla **`OFFICIALS_TEMP`** y seleccionamos **"Importar Datos..."**.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/official1.png) 
2. Seleccionamos el archivo **`officials.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/official2.png) 
3. Visualizamos el archivo CSV y seleccionamos las columnas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/official4.png)  
4. Asignamos las columnas de la tabla temporal para que coincidan con las del archivo CSV.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/official5.png) 
5. Confirmamos la importación y hacemos clic en **"Terminar"** para cargar los datos en **`OFFICIALS_TEMP`**.

---

### **11. Carga de Datos para `OTHER_STATS_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/other.png)
1. Hacemos clic derecho sobre **`OTHER_STATS_TEMP`** y seleccionamos **"Importar Datos..."**.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/other1.png)
2. Elegimos el archivo **`other_stats.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/other2.png)
3. Se previsualizan los datos y seleccionamos las columnas a importar.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/other4.png)

4. Definimos las columnas de la tabla temporal para la correcta asignación de los datos.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/other4.png)
5.  Verificamos la configuración y hacemos clic en **"Terminar"** para completar la carga de datos en **`OTHER_STATS_TEMP`**.

---

### **12. Carga de Datos para `PLAYER_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/player.png)
1. Seleccionamos la tabla **`PLAYER_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/player1.png)
2. Seleccionamos el archivo **`players.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/player2.png)

3. Previsualizamos los datos y seleccionamos las columnas adecuadas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/player4.png)

4. Asignamos las columnas de destino en la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/player5.png)
5. Confirmamos la configuración y completamos la importación haciendo clic en **"Terminar"**.

---

### **13. Carga de Datos para `PLAYE_BY_PLAY_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/pbp.png)
1. Seleccionamos la tabla **`PLAYE_BY_PLAY_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/pbp1.png)
2. Seleccionamos el archivo **`play_by_play.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/pbp2.png)

3. Previsualizamos los datos y seleccionamos las columnas adecuadas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/pbp4.png)

4. Asignamos las columnas de destino en la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/pbp5.png)
5. Confirmamos la configuración y completamos la importación haciendo clic en **"Terminar"**.

### **14. Carga de Datos para `TEAM_DETAILS_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/team_d.png)
1. Seleccionamos la tabla **`TEAM_DETAILS_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/team_d1.png)
2. Seleccionamos el archivo **`team_details.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/team_d2.png)

3. Previsualizamos los datos y seleccionamos las columnas adecuadas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/team_d4.png)

4. Asignamos las columnas de destino en la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/team_d5.png)
5. Confirmamos la configuración y completamos la importación haciendo clic en **"Terminar"**.

### **15. Carga de Datos para `TEAM_HISTORY_TEMP`**

#### **Paso 1: Selección de la Tabla Temporal y Activación del Asistente de Importación**
![Diagrama ER](img/team_h.png)
1. Seleccionamos la tabla **`TEAM_HISTORY_TEMP`** y abrimos el asistente de importación de datos.

#### **Paso 2: Selección del Archivo CSV**
![Diagrama ER](img/team_h1.png)
2. Seleccionamos el archivo **`team_history.csv`** y lo abrimos.

#### **Paso 3: Previsualización de los Datos y Selección de Columnas**
![Diagrama ER](img/team_h2.png)

3. Previsualizamos los datos y seleccionamos las columnas adecuadas para la importación.

#### **Paso 4: Definición de Columnas en la Tabla de Destino**
![Diagrama ER](img/team_h4.png)

4. Asignamos las columnas de destino en la tabla temporal.

#### **Paso 5: Confirmación y Ejecución de la Importación**
![Diagrama ER](img/team_h5.png)
5. Confirmamos la configuración y completamos la importación haciendo clic en **"Terminar"**.

## 4. Historial de cambios

1. **Cambio de opcionalidad**
- **Descripción**: Cambie esto campos para que sea null para poder insertar datos
![Diagrama ER](img/changes/e1.png)

2. **Cambio de greatest_75_flag**
- **Descripción**: Incongruencia en el tipado gretest_75_flag en unta tabla estaba definida como `BLOB` y en otra como `VARCHAR2(2)`

![Diagrama ER](img/changes/e2.png)
![Diagrama ER](img/changes/e2_1.png)

2. **Aumento de tamaño de Nickname**
- **Descripción**: Los nicknames tenían un maximo de 10, y existia un registro que tiene un nickname con 12 caracteres

![Diagrama ER](img/changes/e3_1.png)
![Diagrama ER](img/changes/e3.png)


3. **Aumento de tamaño de Draft_type**
- **Descripción**: Draft_type tenían un maximo de 6, y existia un registro que tiene un nickname con 11 caracteres

![Diagrama ER](img/changes/e5.png)


4. **Pts se cambia a null**
- **Descripción**: Se cambian los puntos para poder recibir nulls debido a que el csv de carga no tenía los datos

![Diagrama ER](img/changes/e4.png)



1. **Nueva Entidad "Physical"**:
   - **Descripción**: Se introdujo la entidad "Physical" que contiene los atributos `height_w_shoes`, `weight`, `wingspan`, entre otros, relacionados con la física de los jugadores.
   - **Razón**: Paraa permitir un análisis más detallado de las características físicas de los jugadores.
![Diagrama ER](img/changes/c1.png)


2. **Relación entre "Players" y "Physical"**:
   - **Descripción**: Se estableció una relación entre "Players" y "Physical". Esto indica que cada jugador tiene un conjunto de datos físicos asociados.
   - **Razón**: Relacionar las características físicas de los jugadores con la entidad "Players" permite un manejo más específico de estos datos en comparación con la estructura original.

![Diagrama ER](img/changes/c1.png)

3. **Atributos Nuevos en "Players"**:
   - **Descripción**: Se añadieron los atributos `height`, `weight`, `wingspan`, y otros en la entidad "Players".
   - **Razón**: Esta adición refuerza la relación entre los jugadores y sus características físicas.

4. **Nueva Entidad "Player_Combine"**:
   - **Descripción**: Aparece una nueva entidad llamada "Player_Combine", con atributos como `id_combine`, `position`, `season`, y una relación con "Players".
   - **Razón**: Para almacenar información sobre las pruebas combinadas de los jugadores, que son típicamente parte de la evaluación de nuevos talentos en la NBA.

5. **Cambio en la Relación entre "Teams" y "Players"**:
   - **Descripción**: La relación entre "Teams" y "Players" ahora está más detallada, mostrando que los jugadores son asignados a un equipo, pero también con un tipo de relación más clara con roles específicos como "inactive_players".
   - **Razón**: Este cambio ayuda a manejar más efectivamente la dinámica de equipos y jugadores activos/inactivos dentro de la base de datos.

6. **Atributos Nuevos en "Teams"**:
   - **Descripción**: La entidad "Teams" ha sido ampliada con atributos como `owner`, `generalManager`, y las relaciones sociales (Facebook, Instagram, etc.), que no estaban presentes en la versión inicial.
   - **Razón**: Para almacenar información adicional sobre los equipos, como su dirección administrativa y presencia en redes sociales.

7. **Eliminación de algunas relaciones**:
   - **Descripción**: Algunas relaciones entre entidades como "Games" y "Season" han sido modificadas o eliminadas, probablemente debido a ajustes en el enfoque del modelo de datos.
   - **Razón**: refinamiento en cómo se gestionan los juegos y las temporadas, posiblemente para simplificar el modelo o adaptarse mejor a nuevas necesidades del proyecto.
