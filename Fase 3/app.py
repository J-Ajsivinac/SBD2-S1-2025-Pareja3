from flask import Flask, jsonify, request
from db_manager import init_sqlite_connection, init_mongo_connection, insert_data_to_mongo, close_sqlite_connection, close_mongo_connection, get_team_wins, get_team_losses, get_player_scores, get_victims

app = Flask(__name__)

# Inicializar las conexiones
def init_db_connections():
    app.config['SQLITE_CONN'], app.config['SQLITE_CURSOR'] = init_sqlite_connection(r'C:\Users\jose_\Downloads\archive\nba.sqlite')
    app.config['MONGO_CLIENT'], app.config['MONGO_DB'], app.config['MONGO_COLLECTION_WINS'], app.config['MONGO_COLLECTION_LOSSES'], app.config['MONGO_COLLECTION_PLAYER_SCORES'], app.config['MONGO_COLLECTION_VICTIMS'] = init_mongo_connection()


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
                'wins': row[3],
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
                'wins': item['wins'],
                'nickname': item['nickname'],
                'team_name': item['team_name'],
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
                'losses': row[3],
            })

        insert_data_to_mongo(app.config['MONGO_COLLECTION_LOSSES'], data_to_insert)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Data loaded into losers collection successfully'}), 200


# Endpoint para consultar los datos de los equipos perdedores desde MongoDB
@app.route('/team_losses', methods=['GET'])
def team_losses():
    try:
        data = app.config['MONGO_COLLECTION_LOSSES'].find()
        results = []
        for item in data:
            results.append({
                'team_id': item['team_id'],
                'losses': item['losses'],
                'nickname': item['nickname'],
                'team_name': item['team_name'],
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
            data_to_insert.append({
                'player_id': row[0],
                'player_name': row[1],
                'games_with_points': row[2],
                'total_points': row[3],
            })

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


@app.teardown_appcontext
def close_connections(exception):
    if 'SQLITE_CONN' in app.config:
        app.config['SQLITE_CONN'].close()
    
    if 'MONGO_CLIENT' in app.config:
        app.config['MONGO_CLIENT'].close()


if __name__ == '__main__':
    app.run(debug=True)
