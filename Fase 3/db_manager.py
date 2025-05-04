# db_manager.py
import sqlite3
from pymongo import MongoClient
from pymongo.errors import PyMongoError

def init_sqlite_connection(db_path):
    """Inicializa la conexión a SQLite y devuelve el cursor."""
    conn = sqlite3.connect(db_path, check_same_thread=False)
    cursor = conn.cursor()
    return conn, cursor

def init_mongo_connection(mongo_uri='mongodb://localhost:27017/', db_name='nba_database'):
    """Inicializa la conexión a MongoDB y devuelve la base de datos y las colecciones."""
    client = MongoClient(mongo_uri)
    db = client[db_name]
    collection_wins = db['team_wins']
    collection_losses = db['team_losses']
    collection_player_scores = db['player_scores']
    collection_victims = db['victims']
    return client, db, collection_wins, collection_losses, collection_player_scores, collection_victims

def close_sqlite_connection(conn):
    """Cierra la conexión a SQLite."""
    if conn:
        conn.close()

def close_mongo_connection(client):
    """Cierra la conexión a MongoDB."""
    if client:
        client.close()

def execute_sql_query(cursor, query, params=None):
    """Ejecuta una consulta SQL y devuelve los resultados."""
    cursor.execute(query, params or [])
    return cursor.fetchall()

def insert_data_to_mongo(collection, data):
    """Inserta datos en la colección de MongoDB."""
    try:
        if data:
            collection.insert_many(data)
    except PyMongoError as e:
        raise PyMongoError(f'MongoDB error: {e}')

# Consultas SQL

def get_team_wins(cursor):
    """Consulta para obtener los equipos ganadores y sus victorias."""
    query = """
        SELECT 
            t.id AS id,
            t.full_name AS nombre_equipo,
            t.nickname AS nick_name,
            COUNT(*) AS wins
        FROM (
            SELECT
                CASE
                    WHEN pts_home > pts_away THEN team_id_home 
                    WHEN pts_away > pts_home THEN team_id_away 
                    ELSE NULL
                END AS team_name
            FROM game
        ) victorias
        INNER JOIN team t ON t.id = victorias.team_name
        GROUP BY t.id, t.full_name, t.nickname
        ORDER BY wins DESC;
    """
    return execute_sql_query(cursor, query)

def get_team_losses(cursor):
    """Consulta para obtener los equipos perdedores y sus derrotas."""
    query = """
        SELECT 
            t.id AS id,
            t.full_name AS nombre_equipo,
            t.nickname AS nick_name,
            COUNT(*) AS losses
        FROM (
            SELECT
                CASE
                    WHEN pts_home < pts_away THEN team_id_home
                    WHEN pts_away < pts_home THEN team_id_away
                    ELSE NULL
                END AS team_name
            FROM game
        ) victorias
        INNER JOIN team t ON t.id = victorias.team_name
        GROUP BY t.id, t.full_name, t.nickname
        ORDER BY losses DESC;
    """
    return execute_sql_query(cursor, query)

def get_player_scores(cursor):
    """Consulta para obtener los puntajes máximos de los jugadores."""
    query = """
        WITH PuntosMaximos AS (
            SELECT
            player1_id,
            player1_name,
            game_id,
            MAX(
                CASE
                WHEN homedescription LIKE '%PTS%' THEN
                    CAST(
                        SUBSTR(
                            homedescription,
                            INSTR(homedescription, '(') + 1,
                            INSTR(homedescription, ' PTS)') - INSTR(homedescription, '(') - 1
                        ) AS INTEGER
                    )
                WHEN visitordescription LIKE '%PTS%' THEN
                    CAST(
                        SUBSTR(
                            visitordescription,
                            INSTR(visitordescription, '(') + 1,
                            INSTR(visitordescription, ' PTS)') - INSTR(visitordescription, '(') - 1
                        ) AS INTEGER
                    )
                ELSE 0
                END
            ) AS puntos_en_juego
            FROM play_by_play
            WHERE homedescription LIKE '%PTS%' OR visitordescription LIKE '%PTS%'
            GROUP BY player1_id, player1_name, game_id
        )
        SELECT
            player1_id,
            player1_name,
            COUNT(DISTINCT game_id) AS juegos_con_puntos,
            SUM(puntos_en_juego) AS puntos_totales
        FROM PuntosMaximos
        GROUP BY player1_id, player1_name;
    """
    return execute_sql_query(cursor, query)

def get_victims(cursor, team_name):
    """Consulta para obtener las víctimas de un equipo específico."""
    query = f"""
        SELECT 
            CASE 
                WHEN wl_home = 'W' THEN team_name_home
                WHEN wl_away = 'W' THEN team_name_away
            END AS equipo,
            CASE 
                WHEN wl_home = 'W' THEN team_name_away
                WHEN wl_away = 'W' THEN team_name_home
            END AS equipo_victima,
            COUNT(*) AS victorias
        FROM game
        WHERE equipo = '{team_name}'
        GROUP BY equipo, equipo_victima
        ORDER BY victorias DESC;
    """
    return execute_sql_query(cursor, query)
