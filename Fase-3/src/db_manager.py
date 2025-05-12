# db_manager.py
import sqlite3
from pymongo import MongoClient
from pymongo.errors import PyMongoError


def init_sqlite_connection(db_path):
    """Inicializa la conexión a SQLite y devuelve el cursor."""
    conn = sqlite3.connect(db_path, check_same_thread=False)
    cursor = conn.cursor()
    return conn, cursor


def init_mongo_connection(
    mongo_uri="mongodb://localhost:27017/", db_name="nba_database"
):
    """Inicializa la conexión a MongoDB y devuelve la base de datos y las colecciones."""
    client = MongoClient(mongo_uri)
    db = client[db_name]
    collection_wins = db["team_wins"]
    collection_losses = db["team_losses"]
    collection_player_scores = db["player_scores"]
    collection_victims = db["victims"]
    collection_stats = db["team_stats"]
    collection_games_details = db["games_details"]
    return (
        client,
        db,
        collection_wins,
        collection_losses,
        collection_player_scores,
        collection_victims,
        collection_stats,
        collection_games_details,
    )


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
        raise PyMongoError(f"MongoDB error: {e}")


# Consultas SQL


def get_team_wins(cursor):
    """Consulta para obtener los equipos ganadores y sus victorias."""
    query = """
        SELECT 
            t.id AS id,
            t.full_name AS nombre_equipo,
            t.nickname AS nick_name,
            td.abbreviation,
            td.yearfounded ,
            td.arena,
            td.arenacapacity,
            td.headcoach,
            td.owner,
            td.generalmanager ,
            td.dleagueaffiliation,
            td.facebook,
            td.instagram,
            td.twitter,
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
        INNER JOIN team_details td ON  td.team_id = t.id
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
            td.abbreviation,
            td.yearfounded ,
            td.arena,
            td.arenacapacity,
            td.headcoach,
            td.owner,
            td.generalmanager ,
            td.dleagueaffiliation,
            td.facebook,
            td.instagram,
            td.twitter,
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
        INNER JOIN team_details td ON  td.team_id = t.id
        GROUP BY t.id, t.full_name, t.nickname
        ORDER BY losses DESC;
    """
    return execute_sql_query(cursor, query)

def get_team_stats(cursor):
    """Consulta unificada para obtener estadísticas completas de victorias y derrotas por equipo."""
    # Obtener victorias
    wins_data = get_team_wins(cursor)
    wins_by_team = {row[0]: row for row in wins_data}  # Indexar por team_id
    
    # Obtener derrotas
    losses_data = get_team_losses(cursor)
    losses_by_team = {row[0]: row for row in losses_data}  # Indexar por team_id
    
    # Combinar los resultados
    combined_results = []
    all_team_ids = set(list(wins_by_team.keys()) + list(losses_by_team.keys()))
    
    for team_id in all_team_ids:
        # Datos base del equipo (usamos datos de victorias si disponibles, sino de derrotas)
        team_data = wins_by_team.get(team_id) or losses_by_team.get(team_id)
        name_team = wins_by_team[team_id][1] if team_id in wins_by_team else losses_by_team[team_id][1]
        victims = get_victims(cursor, name_team)
        # print(victims,name_team)
        # Obtener recuento de victorias y derrotas
        wins = wins_by_team[team_id][14] if team_id in wins_by_team else 0
        losses = losses_by_team[team_id][14] if team_id in losses_by_team else 0
        
        # Crear una entrada combinada
        result = list(team_data[0:14])  # Datos del equipo sin contar wins/losses
        result.append(wins)
        result.append(losses)
        result.append(victims)  # Agregar victimas
        
        combined_results.append(tuple(result))
    
    # Ordenar por victorias (mayor a menor) y luego por derrotas (menor a mayor)
    combined_results.sort(key=lambda x: (-x[14], x[15]))
    
    return combined_results

def get_player_scores(cursor):
    """Consulta para obtener los puntajes máximos de los jugadores."""
    query = """
            WITH
                PuntosMaximos AS (
                    SELECT
                        player1_id,
                        player1_name,
                        game_id,
                        MAX(
                            CASE
                                WHEN homedescription LIKE '%PTS%' THEN CAST(
                                    SUBSTR (
                                        homedescription,
                                        INSTR (homedescription, '(') + 1,
                                        INSTR (homedescription, ' PTS)') - INSTR (homedescription, '(') - 1
                                    ) AS INTEGER
                                )
                                WHEN visitordescription LIKE '%PTS%' THEN CAST(
                                    SUBSTR (
                                        visitordescription,
                                        INSTR (visitordescription, '(') + 1,
                                        INSTR (visitordescription, ' PTS)') - INSTR (visitordescription, '(') - 1
                                    ) AS INTEGER
                                )
                                ELSE 0
                            END
                        ) AS puntos_en_juego
                    FROM
                        play_by_play
                    WHERE
                        homedescription LIKE '%PTS%'
                        OR visitordescription LIKE '%PTS%'
                    GROUP BY
                        player1_id,
                        player1_name,
                        game_id
                )
            SELECT
                player1_id,
                player1_name,
                cpi.birthdate,
                cpi.country ,
                cpi.school,
                cpi.height ,
                cpi.weight ,
                cpi."position" ,
                cpi.jersey ,
                cpi.player_slug,
                cpi.season_exp ,
                cpi.draft_year ,
                cpi.draft_number ,
                t.full_name ,
                t.nickname ,
                t.abbreviation ,
                t.state ,
                t.city ,
                COUNT(DISTINCT game_id) AS juegos_con_puntos,
                SUM(puntos_en_juego) AS puntos_totales
            FROM
                PuntosMaximos
            LEFT JOIN common_player_info cpi on cpi.person_id = player1_id 
            LEFT JOIN team t ON t.id = cpi.team_id
            GROUP BY
                player1_id,
                player1_name
            order by puntos_totales desc;
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


def get_games_data(cursor):
    """Consulta para obtener los datos completos de juegos de forma optimizada."""
    # Consulta principal para datos de juegos
    main_query = """
    SELECT
        g.game_id, g.game_date, g.season_id, g.season_type,
        g.team_id_home, g.team_abbreviation_home, g.team_name_home,
        g.matchup_home, g.wl_home, g.pts_home, g.plus_minus_home,
        g.fgm_home, g.fga_home, g.fg_pct_home, g.fg3m_home, g.fg3a_home, g.fg3_pct_home,
        g.ftm_home, g.fta_home, g.ft_pct_home, g.oreb_home, g.dreb_home, g.reb_home,
        g.ast_home, g.stl_home, g.blk_home, g.tov_home, g.pf_home,
        g.team_id_away, g.team_abbreviation_away, g.team_name_away,
        g.matchup_away, g.wl_away, g.pts_away, g.plus_minus_away,
        g.fgm_away, g.fga_away, g.fg_pct_away, g.fg3m_away, g.fg3a_away, g.fg3_pct_away,
        g.ftm_away, g.fta_away, g.ft_pct_away, g.oreb_away, g.dreb_away, g.reb_away,
        g.ast_away, g.stl_away, g.blk_away, g.tov_away, g.pf_away,
        CASE WHEN g.wl_home = 'W' THEN g.team_name_home ELSE g.team_name_away END as winner
    FROM game g
    """
    
    cursor.execute(main_query)
    columns = [col[0] for col in cursor.description]
    games = []
    game_ids = []
    
    # Crear diccionario de juegos primero
    games_dict = {}
    for row in cursor.fetchall():
        game_data = dict(zip(columns, row))
        game_id = game_data['game_id']
        games_dict[game_id] = game_data
        game_ids.append(game_id)
    
    # Función auxiliar para obtener datos relacionados en lotes pequeños
    def get_related_data(table_name):
        if not game_ids:
            return {}
            
        result = {}
        columns = None
        # Procesar en lotes de 500 para evitar "too many SQL variables"
        batch_size = 500
        
        for i in range(0, len(game_ids), batch_size):
            batch = game_ids[i:i+batch_size]
            placeholders = ','.join(['?'] * len(batch))
            query = f"SELECT * FROM {table_name} WHERE game_id IN ({placeholders})"
            cursor.execute(query, batch)
            
            if not cursor.description:
                continue
                
            if columns is None:
                columns = [col[0] for col in cursor.description]
            
            for row in cursor.fetchall():
                data = dict(zip(columns, row))
                result[data['game_id']] = data
            
        return result
    
    # Obtener datos relacionados en lote
    related_tables = ['line_score', 'game_summary', 'game_info', 'other_stats']
    related_data = {table: get_related_data(table) for table in related_tables}
    
    # Completar y estructurar los datos de juegos con la información relacionada
    for game_id, game_data in games_dict.items():
        # Extraer el año de la temporada desde game_summary si está disponible
        season_year = None
        if game_id in related_data['game_summary'] and 'season' in related_data['game_summary'][game_id]:
            season_year = related_data['game_summary'][game_id]['season']
        
        structured_game = {
            'id': game_id,
            'date': game_data['game_date'],
            'season': {
                'id': game_data['season_id'],
                'type': game_data['season_type'],
                'year': season_year
            },
            'teams': {
                'home': {
                    'id': game_data['team_id_home'],
                    'abbreviation': game_data['team_abbreviation_home'],
                    'name': game_data['team_name_home'],
                    'matchup': game_data['matchup_home'],
                    'result': game_data['wl_home'],
                    'stats': {
                        'points': game_data['pts_home'],
                        'plus_minus': game_data['plus_minus_home'],
                        'shooting': {
                            'field_goals': {
                                'made': game_data['fgm_home'],
                                'attempted': game_data['fga_home'],
                                'percentage': game_data['fg_pct_home']
                            },
                            'three_points': {
                                'made': game_data['fg3m_home'],
                                'attempted': game_data['fg3a_home'],
                                'percentage': game_data['fg3_pct_home']
                            },
                            'free_throws': {
                                'made': game_data['ftm_home'],
                                'attempted': game_data['fta_home'],
                                'percentage': game_data['ft_pct_home']
                            }
                        },
                        'rebounds': {
                            'offensive': game_data['oreb_home'],
                            'defensive': game_data['dreb_home'],
                            'total': game_data['reb_home']
                        },
                        'assists': game_data['ast_home'],
                        'steals': game_data['stl_home'],
                        'blocks': game_data['blk_home'],
                        'turnovers': game_data['tov_home'],
                        'fouls': game_data['pf_home']
                    }
                },
                'away': {
                    'id': game_data['team_id_away'],
                    'abbreviation': game_data['team_abbreviation_away'],
                    'name': game_data['team_name_away'],
                    'matchup': game_data['matchup_away'],
                    'result': game_data['wl_away'],
                    'stats': {
                        'points': game_data['pts_away'],
                        'plus_minus': game_data['plus_minus_away'],
                        'shooting': {
                            'field_goals': {
                                'made': game_data['fgm_away'],
                                'attempted': game_data['fga_away'],
                                'percentage': game_data['fg_pct_away']
                            },
                            'three_points': {
                                'made': game_data['fg3m_away'],
                                'attempted': game_data['fg3a_away'],
                                'percentage': game_data['fg3_pct_away']
                            },
                            'free_throws': {
                                'made': game_data['ftm_away'],
                                'attempted': game_data['fta_away'],
                                'percentage': game_data['ft_pct_away']
                            }
                        },
                        'rebounds': {
                            'offensive': game_data['oreb_away'],
                            'defensive': game_data['dreb_away'],
                            'total': game_data['reb_away']
                        },
                        'assists': game_data['ast_away'],
                        'steals': game_data['stl_away'],
                        'blocks': game_data['blk_away'],
                        'turnovers': game_data['tov_away'],
                        'fouls': game_data['pf_away']
                    }
                }
            },
            'winner': game_data['winner'],
            'details': {}
        }
        
        # Agregar los datos relacionados a la estructura
        for table in related_tables:
            if game_id in related_data[table]:
                table_data = related_data[table][game_id]
                # Eliminar el game_id para evitar redundancia
                if 'game_id' in table_data:
                    del table_data['game_id']
                structured_game['details'][table] = table_data
        
        games.append(structured_game)
    
    return games