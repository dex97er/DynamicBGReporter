local addonName, addon = ...
addon = addon or {}  -- Ensure addon table exists
addon.bgConfigs = {
    -- Arathi Basin
    [1461] = {
        name = "Arathi Basin",
        locations = {"LM", "BS", "GM", "ST", "Farm"},
        areas = {
            [1] = "LM",
            [2] = "GM",
            [3] = "BS",
            [4] = "Farm",
            [5] = "ST"
        },
        subzones = {
            ["Lumber Mill"] = {"Sägewerk", "Lumber Mill", "Scierie", "Serrería", "Лесопилка"},
            ["Blacksmith"] = {"Schmiede", "Blacksmith", "Forge", "Herrería", "Кузница"},
            ["Gold Mine"] = {"Goldmine", "Gold Mine", "Mine d'or", "Mina de oro", "Золотая шахта"},
            ["Stables"] = {"Ställe", "Stables", "Écuries", "Establo", "Конюшня"},
            ["Farm"] = {"Hof", "Farm", "Ferme", "Granja", "Ферма"}
        }
    },
    -- Eye of the Storm
    [1956] = {
        name = "Eye of the Storm",
        locations = {"FR", "MT", "MID", "DR", "B11"},
        areas = {
            [1] = "FR",
            [2] = "MT",
            [3] = "MID",
            [4] = "DR",
            [5] = "B11"
        },
        subzones = {
            ["Fel Reaver Ruins"] = {"Teufelshäscherruinen", "Fel Reaver Ruins", "Ruines du saccageur gangrené", "Ruinas del Atracador Vil", "Руины Скверноботов"},
            ["Mage Tower"] = {"Magierturm", "Mage Tower", "Tour des mages", "Torre de los Magos", "Башня Магов"},
            ["Center"] = {"Mitte", "Center", "Centre", "Centro", "Центр"},
            ["Draenei Ruins"] = {"Draeneiruinen", "Draenei Ruins", "Ruines draeneï", "Ruinas Draenei", "Руины дренеев"},
            ["Blood Elf Tower"] = {"Blutelfenturm", "Blood Elf Tower", "Tour des elfes de sang", "Torre de los Elfos de Sangre", "Башня Кровавых эльфов"}
        }
    },
    -- Battle for Gilneas
    [275] = {
        name = "Battle for Gilneas",
        locations = {"LH", "WW", "Mines"},
        areas = {
            [1] = "LH",
            [2] = "WW",
            [3] = "Mines"
        },
        subzones = {
            ["Lighthouse"] = {"Leuchtturm", "Lighthouse", "Phare", "Faro", "Маяк"},
            ["Waterworks"] = {"Wasserwerk", "Waterworks", "Station d'épuration", "Planta de tratamiento", "Водоочистная станция"},
            ["Mines"] = {"Minen", "Mines", "Mines", "Minas", "Рудник"}
        }
    },
    -- Isle of Conquest
    [4710] = {
        name = "Isle of Conquest",
        locations = {"Hangar", "Workshop", "Docks", "Refinery", "Quarry"},
        areas = {
            [1] = "Hangar",
            [2] = "Workshop",
            [3] = "Docks",
            [4] = "Refinery",
            [5] = "Quarry"
        },
        subzones = {
            ["Hangar"] = {"Hangar", "Hangar", "Hangar", "Hangar", "Ангар"},
            ["Workshop"] = {"Werkstatt", "Workshop", "Atelier", "Taller", "Мастерская"},
            ["Docks"] = {"Docks", "Docks", "Docks", "Muelles", "Доки"},
            ["Refinery"] = {"Raffinerie", "Refinery", "Raffinerie", "Refinería", "Нефтезавод"},
            ["Quarry"] = {"Steinbruch", "Quarry", "Carrière", "Cantera", "Каменоломня"}
        }
    }
}

-- You can add other configuration variables here
addon.playerCounts = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}

-- Return the addon table at the end of the file
return addon