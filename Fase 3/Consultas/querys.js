const jugadorMasAnotador = db.player_scores
    .find()
    .sort({ "statistics.total_points": -1 }) // Ordenar por los puntos totales en orden descendente
    .limit(1); // Limitar a un solo jugador

// Mostrar la información del jugador más anotador
if (jugadorMasAnotador.hasNext()) {
    const jugador = jugadorMasAnotador.next();
    print("🏆 **Jugador Más Anotador de la Historia**");
    print("-------------------------------------------------");
    print(`🎽 **Nombre del Jugador:** ${jugador.player_name}`);
    print(`🏀 **Puntos Totales:** ${jugador.statistics.total_points}`);
    print(`🕹️ **Juegos con puntos:** ${jugador.statistics.games_with_points}`);
    print("\n-----------------------------");
} else {
    print("❌ No se encontró información sobre el jugador más anotador.");
}

const top10EquiposGanadores = db.team_stats
    .find()
    .sort({ "stats.wins": -1 }) // Ordenar por el número de victorias de manera descendente
    .limit(10); // Limitar a los 10 primeros equipos

// Mostrar la información del Top 10 de equipos más ganadores
print("🏆 **Top 10 Equipos Más Ganadores de la Historia**");
print("-------------------------------------------------");

let index = 1; // Iniciar un índice para numerar los equipos

top10EquiposGanadores.forEach((equipo) => {
    // Asegurarse de que 'wins' sea un número antes de mostrarlo
    const victorias = Number(equipo.stats.wins);

    if (!isNaN(victorias)) {
        print(`${index}. ${equipo.team_name} - Victorias: ${victorias}`);
        index++; // Incrementar el índice después de mostrar cada equipo
    } else {
        print(`${index}. ${equipo.team_name} - Victorias: No disponible`);
        index++; // Incrementar el índice incluso si los datos no están disponibles
    }
});

print("\n-----------------------------");

const top10EquiposPerdedores = db.team_stats
    .find()
    .sort({ "stats.losses": -1 }) // Ordenar por el número de derrotas de manera descendente
    .limit(10); // Limitar a los 10 primeros equipos

// Mostrar la información del Top 10 de equipos más perdedores
print("⚠️ **Top 10 Equipos Más Perdedores de la Historia**");
print("--------------------------------------------------");

let index = 1; // Iniciar un índice para numerar los equipos

top10EquiposPerdedores.forEach((equipo) => {
    // Asegurarse de que 'losses' sea un número antes de mostrarlo
    const derrotas = Number(equipo.stats.losses);

    if (!isNaN(derrotas)) {
        print(`${index}. ${equipo.team_name} - Derrotas: ${derrotas}`);
        index++; // Incrementar el índice después de mostrar cada equipo
    } else {
        print(`${index}. ${equipo.team_name} - Derrotas: No disponible`);
        index++; // Incrementar el índice incluso si los datos no están disponibles
    }
});

print("\n-----------------------------");
