from flask import Flask, jsonify, request
from db_manager import init_sqlite_connection, init_mongo_connection, insert_data_to_mongo, get_games_data, close_mongo_connection, get_team_wins, get_team_losses, get_player_scores, get_victims,get_team_stats

app = Flask(__name__)

# Inicializar las conexiones
def init_db_connections():
    app.config['SQLITE_CONN'], app.config['SQLITE_CURSOR'] = init_sqlite_connection(r'C:\Users\ajsivinac\Downloads\nba.sqlite\nba.sqlite')
    app.config['MONGO_CLIENT'], app.config['MONGO_DB'], app.config['MONGO_COLLECTION_WINS'], app.config['MONGO_COLLECTION_LOSSES'], app.config['MONGO_COLLECTION_PLAYER_SCORES'], app.config['MONGO_COLLECTION_VICTIMS'], app.config['MONGO_COLLECTION_TEAM_STATS'], app.config['MONGO_COLLECTION_GAMES_DETAILS'] = init_mongo_connection()


@app.before_request
def before_first_request():
    init_db_connections()

# Endpoint para cargar los datos de los equipos ganadores de SQLite a MongoDB
@app.route('/team_wins', methods=['POST'])
def load_team_wins():
    try:
        results = get_team_wins(app.config['SQLITE_CURSOR'])
        
        if not results:
            return jsonify({'error': 'No data found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    try:
        # Insertar los resultados en MongoDB para los ganadores
        data_to_insert = []
        for row in results:
            data_to_insert.append({
                'team_id': row[0],
                'team_name': row[1],
                'nickname': row[2],
                'abbreviation': row[3],
                'year_founded': row[4],
                'arena': row[5],
                'arena_capacity': row[6],
                'head_coach': row[7],
                'owner': row[8],
                'general_manager': row[9],
                'dleague': row[10],
                'facebook': row[11],
                'instagram': row[12],
                'twitter': row[13],
                'wins': row[14],
            })

        insert_data_to_mongo(app.config['MONGO_COLLECTION_WINS'], data_to_insert)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Data loaded into winners collection successfully'}), 200


# Endpoint para consultar los datos de los equipos ganadores desde MongoDB
@app.route('/team_wins', methods=['GET'])
def team_wins():
    try:
        data = app.config['MONGO_COLLECTION_WINS'].find()
        results = []
        for item in data:
            results.append({
                'team_id': item['team_id'],
                'team_name': item['team_name'],
                'nickname': item['nickname'],
                'abbreviation': item['abbreviation'],
                'year_founded': item['year_founded'],
                'arena': item['arena'],
                'arena_capacity': item['arena_capacity'],
                'head_coach': item['head_coach'],
                'owner': item['owner'],
                'general_manager': item['general_manager'],
                'dleague': item['dleague'],
                'facebook': item['facebook'],
                'instagram': item['instagram'],
                'twitter': item['twitter'],
                'wins': item['wins'],
            })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    if not results:
        return jsonify({'error': 'No data found'}), 404

    return jsonify(results), 200


# Endpoint para cargar los datos de los equipos perdedores de SQLite a MongoDB
@app.route('/team_losses', methods=['POST'])
def load_team_losses():
    try:
        results = get_team_losses(app.config['SQLITE_CURSOR'])
        
        if not results:
            return jsonify({'error': 'No data found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    try:
        # Insertar los resultados de los perdedores en MongoDB
        data_to_insert = []
        for row in results:
            data_to_insert.append({
                'team_id': row[0],
                'team_name': row[1],
                'nickname': row[2],
                'abbreviation': row[3],
                'year_founded': row[4],
                'arena': row[5],
                'arena_capacity': row[6],
                'head_coach': row[7],
                'owner': row[8],
                'general_manager': row[9],
                'dleague': row[10],
                'facebook': row[11],
                'instagram': row[12],
                'twitter': row[13],
                'losses': row[3],
            })

        insert_data_to_mongo(app.config['MONGO_COLLECTION_LOSSES'], data_to_insert)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Data loaded into losers collection successfully'}), 200

@app.route('/team_stats', methods=['POST'])
def load_team_stats():
    """Endpoint para cargar estadísticas completas de equipos desde SQLite a MongoDB."""
    try:
        # Obtener datos combinados de equipos
        results = get_team_stats(app.config['SQLITE_CURSOR'])
        
        if not results:
            return jsonify({'error': 'No se encontraron datos de equipos'}), 404
        # print(results[0])
        # Preparar datos para MongoDB
        data_to_insert = []
        for row in results:
            # Calcular estadísticas adicionales
            wins = row[14] if row[14] is not None else 0
            losses = row[15] if row[15] is not None else 0
            total_games = wins + losses
            win_percentage = round((wins / total_games * 100), 2) if total_games > 0 else 0
            print(row[16])
            
            # formatear datos de las victimas
            all_victims_formatted = [
                {
                    "equipo_victima": victima,
                    "victorias": victorias
                }
            for equipo, victima, victorias in row[16]
]

            data_to_insert.append({
                'team_id': row[0],
                'team_name': row[1],
                'nickname': row[2],
                'abbreviation': row[3],
                'stats': {
                    'wins': wins,
                    'losses': losses,
                    'total_games': total_games,
                    'win_percentage': win_percentage
                },
                'details': {
                    'year_founded': row[4],
                    'arena': row[5],
                    'arena_capacity': row[6],
                    'head_coach': row[7],
                    'owner': row[8],
                    'general_manager': row[9],
                    'dleague_affiliation': row[10]
                },
                'social_media': {
                    'facebook': row[11],
                    'instagram': row[12],
                    'twitter': row[13]
                },
                "victims": all_victims_formatted,
            })

        # Insertar datos en MongoDB
        insert_data_to_mongo(app.config['MONGO_COLLECTION_TEAM_STATS'], data_to_insert)

        return jsonify({
            'message': 'Datos de equipos cargados exitosamente en la colección teams',
            'count': len(data_to_insert)
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Endpoint para consultar los datos de los equipos perdedores desde MongoDB
@app.route('/team_losses', methods=['GET'])
def team_losses():
    try:
        data = app.config['MONGO_COLLECTION_LOSSES'].find()
        results = []
        for item in data:
            results.append({
                'team_id': item['team_id'],
                'team_name': item['team_name'],
                'nickname': item['nickname'],
                'abbreviation': item['abbreviation'],
                'year_founded': item['year_founded'],
                'arena': item['arena'],
                'arena_capacity': item['arena_capacity'],
                'head_coach': item['head_coach'],
                'owner': item['owner'],
                'general_manager': item['general_manager'],
                'dleague': item['dleague'],
                'facebook': item['facebook'],
                'instagram': item['instagram'],
                'twitter': item['twitter'],
                'losses': item['losses'],
            })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    if not results:
        return jsonify({'error': 'No data found'}), 404

    return jsonify(results), 200


# Endpoint para cargar los datos de los jugadores con sus puntos máximos
@app.route('/player_scores', methods=['POST'])
def load_player_scores():
    try:
        results = get_player_scores(app.config['SQLITE_CURSOR'])
        
        if not results:
            return jsonify({'error': 'No data found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    try:
        # Insertar los resultados de los jugadores con sus puntos máximos en MongoDB
        data_to_insert = []
        for row in results:
            player = {
                "player_id": row[0],
                "player_name": row[1],
                "nickname": row[14],
                "slug": row[9],
                "personal_info": {
                    "birth_date": row[2],
                    "country": row[3],
                    "state": row[16],
                    "city": row[17],
                    "school": row[4],
                    "height": row[5],
                    "weight": row[6],
                },
                "career": {
                    "position": row[7],
                    "jersey_number": row[8],
                    "season_experience": row[10],
                    "draft": {
                        "year": row[11],
                        "number": row[12]
                    }
                },
                "team": {
                    "name": row[13],
                    "abbreviation": row[15]
                },
                "statistics": {
                    "games_with_points": row[18],
                    "total_points": row[19]
                }
            }
            data_to_insert.append(player)

        insert_data_to_mongo(app.config['MONGO_COLLECTION_PLAYER_SCORES'], data_to_insert)


    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Player scores data loaded successfully'}), 200


# Endpoint para consultar los datos de los jugadores con sus puntos máximos desde MongoDB
@app.route('/player_scores', methods=['GET'])
def player_scores():
    try:
        data = app.config['MONGO_COLLECTION_PLAYER_SCORES'].find()
        results = []
        for item in data:
            results.append({
                'player_id': item['player_id'],
                'player_name': item['player_name'],
                'birth_date': item['birth_date'],
                'country': item['country'],
                'school': item['school'],
                'height': item['height'],
                'weight': item['weight'],
                'position': item['position'],
                'jersey_number': item['jersey_number'],
                'player_slug': item['player_slug'],
                'season_experience': item['season_experience'],
                'draft_year': item['draft_year'],
                'draft_number': item['draft_number'],
                'team_name': item['team_name'],
                'nickname': item['nickname'],
                'abbreviation': item['abbreviation'],
                'state': item['state'],
                'city': item['city'],
                'games_with_points': item['games_with_points'],
                'total_points': item['total_points'],
            })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    if not results:
        return jsonify({'error': 'No data found'}), 404

    return jsonify(results), 200

# Endpoint para cargar los datos de las víctimas desde SQLite a MongoDB
@app.route('/victims', methods=['POST'])
def load_victims():
    try:
        team_name = request.args.get('team_name', 'Boston Celtics')  # Cambia por el nombre del equipo
        results = get_victims(app.config['SQLITE_CURSOR'], team_name)
        
        if not results:
            return jsonify({'error': 'No data found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    try:
        # Insertar los resultados de las víctimas en MongoDB
        data_to_insert = []
        for row in results:
            data_to_insert.append({
                'equipo': row[0],
                'equipo_victima': row[1],
                'victorias': row[2],
            })

        insert_data_to_mongo(app.config['MONGO_COLLECTION_VICTIMS'], data_to_insert)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Data loaded into victims collection successfully'}), 200


# Endpoint para consultar los datos de las víctimas desde MongoDB
@app.route('/victims', methods=['GET'])
def victims():
    try:
        data = app.config['MONGO_COLLECTION_VICTIMS'].find()
        results = []
        for item in data:
            results.append({
                'equipo': item['equipo'],
                'equipo_victima': item['equipo_victima'],
                'victorias': item['victorias'],
            })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    if not results:
        return jsonify({'error': 'No data found'}), 404

    return jsonify(results), 200

@app.route('/api/load_games', methods=['POST'])
def load_full_games():
    try:
        # Obtener los datos de juegos usando la función del db_manager
        results = get_games_data(app.config['SQLITE_CURSOR'])
        
        if not results:
            return jsonify({'error': 'No games data found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    try:
        # Insertar los resultados en MongoDB
        games_collection = app.config['MONGO_DB']['games_details']
        
        # Opcional: limpiar datos existentes si se solicita
        force = request.args.get('force', '').lower() == 'true'
        if force:
            games_collection.delete_many({})
            
        # Insertar datos usando tu función existente
        insert_data_to_mongo(games_collection, results)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Game data loaded successfully', 'count': len(results)}), 200


@app.route('/api/chicago_bulls', methods=['GET'])
def get_chicago_bulls_players():
    try:
        # Obtener la colección
        collection = app.config['MONGO_COLLECTION_PLAYER_SCORES']
        results = collection.find({"team.name": "Chicago Bulls"})

        players = []
        for player in results:
            players.append({
                'player_id': player.get('player_id'),
                'player_name': player.get('player_name'),
                'team_name': player.get('team', {}).get('name'),
                'position': player.get('career', {}).get('position'),
                'height': player.get('personal_info', {}).get('height'),
                'weight': player.get('personal_info', {}).get('weight'),
                'birth_date': player.get('personal_info', {}).get('birth_date'),
                'country': player.get('personal_info', {}).get('country'),
            })

        if not players:
            return jsonify({'error': 'No data found'}), 404

        return jsonify(players), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.teardown_appcontext
def close_connections(exception):
    if 'SQLITE_CONN' in app.config:
        app.config['SQLITE_CONN'].close()
    
    if 'MONGO_CLIENT' in app.config:
        app.config['MONGO_CLIENT'].close()


if __name__ == '__main__':
    app.run(debug=True)
