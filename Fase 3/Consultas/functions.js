function buscarInfo(tipo, nombre) {
    if (tipo === "player") {
        const jugador = db.player_scores.findOne({
            player_name: { $regex: `^${nombre}$`, $options: "i" },
        });

        if (jugador) {
            print("🎯 **Reporte de Información del Jugador**:\n");
            print("-------------------------------------------------");
            print(`🧑‍🦱 **Nombre del Jugador:** ${jugador.player_name}`);
            print(`🏆 **Estadísticas:**`);
            print(
                `- Juegos con puntos: ${jugador.statistics.games_with_points}`
            );
            print(`- Puntos totales: ${jugador.statistics.total_points}`);
            print("\n📅 **Información Personal:**");
            print(
                `- Fecha de nacimiento: ${
                    jugador.personal_info.birth_date || "N/A"
                }`
            );
            print(`- País: ${jugador.personal_info.country || "N/A"}`);
            print(`- Estatura: ${jugador.personal_info.height || "N/A"}`);
            print(`- Peso: ${jugador.personal_info.weight || "N/A"}`);
            print("\n🎮 **Carrera:**");
            print(`- Posición: ${jugador.career.position || "N/A"}`);
            print(
                `- Número de camiseta: ${jugador.career.jersey_number || "N/A"}`
            );
            print(
                `- Experiencia de temporada: ${
                    jugador.career.season_experience || "N/A"
                }`
            );
            print("\n-----------------------------");
        } else {
            print(`❌ No se encontró ningún jugador con el nombre: ${nombre}`);
        }
    } else if (tipo === "team") {
        const equipo = db.team_stats.findOne(
            {
                $or: [
                    { team_name: { $regex: `^${nombre}$`, $options: "i" } },
                    { nickname: { $regex: `^${nombre}$`, $options: "i" } },
                    { abbreviation: { $regex: `^${nombre}$`, $options: "i" } },
                ],
            },
            { victims: { $slice: 10 } }
        );

        if (equipo) {
            print("🏀 **Reporte de Información del Equipo**:\n");
            print("-------------------------------------------------");
            print(`📅 **Nombre del Equipo:** ${equipo.team_name}`);
            print(`🏆 **Estadísticas:**`);
            print(`- Victorias: ${equipo.stats.wins}`);
            print(`- Derrotas: ${equipo.stats.losses}`);
            print(`- Juegos totales: ${equipo.stats.total_games}`);
            print(`- Porcentaje de victorias: ${equipo.stats.win_percentage}%`);
            print("\n🏟️ **Detalles del Equipo:**");
            print(`- Año de fundación: ${equipo.details.year_founded}`);
            print(`- Arena: ${equipo.details.arena}`);
            print(`- Capacidad de la arena: ${equipo.details.arena_capacity}`);
            print(`- Entrenador principal: ${equipo.details.head_coach}`);
            print(`- Propietario: ${equipo.details.owner}`);
            print(`- Gerente general: ${equipo.details.general_manager}`);
            print("\n🔗 **Redes Sociales:**");
            print(`- Facebook: ${equipo.social_media.facebook}`);
            print(`- Instagram: ${equipo.social_media.instagram}`);
            print(`- Twitter: ${equipo.social_media.twitter}`);

            print("\n-----------------------------");
        } else {
            print(`❌ No se encontró ningún equipo con el nombre: ${nombre}`);
        }
    } else {
        print("⚠️ Parámetro 'tipo' inválido. Usa 'player' o 'team'.");
    }
}

function obtenerVictimasFavoritas(nombreEquipo) {
    const equipo = db.team_stats.findOne(
        {
            $or: [
                { team_name: { $regex: `^${nombreEquipo}$`, $options: "i" } },
                { nickname: { $regex: `^${nombreEquipo}$`, $options: "i" } },
                {
                    abbreviation: {
                        $regex: `^${nombreEquipo}$`,
                        $options: "i",
                    },
                },
            ],
        },
        { victims: { $slice: 10 } }
    ); // Limitar a los primeros 10 elementos en 'victims'

    if (equipo) {
        print("📊 **Victorias contra otros Equipos:**");
        equipo.victims.forEach((victima, index) => {
            print(
                `- ${index + 1}. ${victima.equipo_victima}: ${
                    victima.victorias
                } victorias`
            );
        });
        print("\n-----------------------------");
    } else {
        print(`❌ No se encontró ningún equipo con el nombre: ${nombreEquipo}`);
    }
}
