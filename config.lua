local addonName, addon = ... 
addon = addon or {}  -- Stelle sicher, dass die addon-Tabelle existiert
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
            ["Farm"] = {"Hof", "Farm", "Ferme", "Granja", "Ферма"},
            ["Blacksmith Horde"] = {"Schmiede der Horde", "Blacksmith Horde", "Forge de la Horde", "Herrería de la Horda", "Кузница Орды"},
            ["Defiler's Den"] = {"Höhle der Entweihten", "Defiler's Den", "Antre des Profanateurs", "Guarida de los Rapiñadores", "Логово Осквернителей"},
            ["Alliance Trollbane Hall"] = {"Trollbanhalle der Allianz", "Alliance Trollbane Hall", "Salle Trollbane de l'Alliance", "Sala Trollbane de la Alianza", "Зал Троллебоя Альянса"}
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
        locations = {"LH", "WW", "Mines", "BTR", "AGS", "HL", "OL"},
        areas = { 
            [1] = "LH", 
            [2] = "WW", 
            [3] = "Mines"
        }, 
        subzones = { 
            ["Lighthouse"] = {"Leuchtturm", "Lighthouse", "Phare", "Faro", "Маяк"}, 
            ["Waterworks"] = {"Wasserwerk", "Waterworks", "Station d'épuration", "Planta de tratamiento", "Водоочистная станция"}, 
            ["Mines"] = {"Minen", "Mines", "Mines", "Minas", "Рудник"},
            ["Beneath The Double Rainbow"] = {"Unter dem Doppelregenbogen", "Beneath The Double Rainbow", "Sous le Double Arc-en-ciel", "Bajo el Doble Arcoíris", "Под Двойной Радугой"},
            ["Alliance Gilnean Stronghold"] = {"Gilnearische Festung der Allianz", "Alliance Gilnean Stronghold", "Bastion gilnéen de l'Alliance", "Bastión gilneano de la Alianza", "Гилнеасский оплот Альянса"},
            ["Horde Landing"] = {"Horde-Landeplatz", "Horde Landing", "Zone de débarquement de la Horde", "Desembarco de la Horda", "Высадка Орды"},
            ["The Overlook"] = {"Der Ausblick", "The Overlook", "Le Surplomb", "El Mirador", "Дозорный пункт"}
        } 
    }, 
    -- Isle of Conquest
    [4710] = { 
        name = "Isle of Conquest", 
        locations = {"Hangar", "Workshop", "Docks", "Refinery", "Quarry", "Alliance Keep", "Horde Keep"}, 
        areas = { 
            [1] = "Hangar", 
            [2] = "Workshop", 
            [3] = "Docks", 
            [4] = "Refinery", 
            [5] = "Quarry",
            [6] = "Alliance Keep",
            [7] = "Horde Keep"
        }, 
        subzones = { 
            ["Hangar"] = {"Hangar", "Hangar", "Hangar", "Hangar", "Ангар"}, 
            ["Workshop"] = {"Werkstatt", "Workshop", "Atelier", "Taller", "Мастерская"}, 
            ["Docks"] = {"Docks", "Docks", "Docks", "Muelles", "Доки"}, 
            ["Refinery"] = {"Raffinerie", "Refinery", "Raffinerie", "Refinería", "Нефтезавод"}, 
            ["Quarry"] = {"Steinbruch", "Quarry", "Carrière", "Cantera", "Каменоломня"},
            ["Alliance Keep"] = {"Allianzfestung", "Alliance Keep", "Donjon de l'Alliance", "Fortaleza de la Alianza", "Крепость Альянса"},
            ["Horde Keep"] = {"Hordefestung", "Horde Keep", "Donjon de la Horde", "Fortaleza de la Horda", "Крепость Орды"}
        } 
    }
}

-- You can add other configuration variables here 
addon.playerCounts = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"} 
 
-- Return the addon table at the end of the file 
return addon