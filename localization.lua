local addonName, addon = ...
addon = addon or {}  -- Ensure addon table exists

addon.L = {
    enUS = {
        ["You are at: %s"] = "You are at: %s",
        ["Location unknown"] = "Location unknown",
        ["Not in Battleground"] = "Not in Battleground",
    },
    deDE = {
        ["You are at: %s"] = "Du bist bei: %s",
        ["Location unknown"] = "Standort unbekannt",
        ["Not in Battleground"] = "Nicht im Schlachtfeld",
    },
    -- Add other language localizations here
}

addon.subzoneTranslations = {
    deDE = {
        -- Arathi Basin (Arathibecken)
        ["Die Ställe"] = "ST",
        ["Die Schmiede"] = "BS",
        ["Die Sägemühle"] = "LM",
        ["Die Goldmine"] = "GM",
        ["Der Hof"] = "Farm",

        -- Eye of the Storm (Auge des Sturms)
        ["Blutelfenturm"] = "B11",
        ["Draenei-Ruinen"] = "DR",
        ["Teufelswächterruinen"] = "FR",
        ["Magierturm"] = "MT",
        ["Mitte"] = "MID",  -- Center Flag

        -- Battle for Gilneas (Schlacht um Gilneas)
        ["Der Leuchtturm"] = "LH",
        ["Die Wasserwerke"] = "WW",
        ["Die Minen"] = "Mines",

        -- Isle of Conquest (Insel der Eroberung)
        ["Die Docks"] = "Docks",
        ["Die Werkstatt"] = "Workshop",
        ["Der Hangar"] = "Hangar",
        ["Der Steinbruch"] = "Quarry",
        ["Die Raffinerie"] = "Refinery",
    },
    enUS = {
        -- Arathi Basin (Arathi Basin)
        ["Stables"] = "ST",
        ["Blacksmith"] = "BS",
        ["Lumber Mill"] = "LM",
        ["Gold Mine"] = "GM",
        ["Farm"] = "Farm",

        -- Eye of the Storm (Eye of the Storm)
        ["Blood Elf Tower"] = "B11",
        ["Draenei Ruins"] = "DR",
        ["Fel Reaver Ruins"] = "FR",
        ["Mage Tower"] = "MT",
        ["Center Flag"] = "MID",  -- Center Flag

        -- Battle for Gilneas (Battle for Gilneas)
        ["Lighthouse"] = "LH",
        ["Waterworks"] = "WW",
        ["Mines"] = "Mines",

        -- Isle of Conquest (Isle of Conquest)
        ["Docks"] = "Docks",
        ["Workshop"] = "Workshop",
        ["Hangar"] = "Hangar",
        ["Quarry"] = "Quarry",
        ["Refinery"] = "Refinery",
    },
    frFR = {
        -- Bassin Arathi
        ["Écuries"] = "ST",
        ["Forge"] = "BS",
        ["Scierie"] = "LM",
        ["Mine d'or"] = "GM",
        ["Ferme"] = "Farm",
        
        -- L'Œil du cyclone
        ["Tour des elfes de sang"] = "B11",
        ["Ruines draeneï"] = "DR",
        ["Ruines du saccageur gangrené"] = "FR",
        ["Tour des mages"] = "MT",
        ["Drapeau central"] = "MID",
        
        -- La bataille de Gilnéas
        ["Phare"] = "LH",
        ["Station d'épuration"] = "WW",
        ["Mines"] = "Mines",
        
        -- Île des Conquérants
        ["Docks"] = "Docks",
        ["Atelier"] = "Workshop",
        ["Hangar"] = "Hangar",
        ["Carrière"] = "Quarry",
        ["Raffinerie"] = "Refinery",
    },
    esES = {
        -- Cuenca de Arathi
        ["Establos"] = "ST",
        ["Herrería"] = "BS",
        ["Serrería"] = "LM",
        ["Mina de oro"] = "GM",
        ["Granja"] = "Farm",
        
        -- Ojo de la Tormenta
        ["Torre de los Elfos de Sangre"] = "B11",
        ["Ruinas Draenei"] = "DR",
        ["Ruinas del Atracador Vil"] = "FR",
        ["Torre de los Magos"] = "MT",
        ["Bandera central"] = "MID",
        
        -- Batalla por Gilneas
        ["Faro"] = "LH",
        ["Planta de tratamiento"] = "WW",
        ["Minas"] = "Mines",
        
        -- Isla de la Conquista
        ["Muelles"] = "Docks",
        ["Taller"] = "Workshop",
        ["Hangar"] = "Hangar",
        ["Cantera"] = "Quarry",
        ["Refinería"] = "Refinery",
    },
    itIT = {
        -- Bacino d'Arathi
        ["Stalle"] = "ST",
        ["Fabbro"] = "BS",
        ["Segheria"] = "LM",
        ["Miniera d'Oro"] = "GM",
        ["Fattoria"] = "Farm",
        
        -- Occhio del Ciclone
        ["Torre degli Elfi del Sangue"] = "B11",
        ["Rovine Draenei"] = "DR",
        ["Rovine del Falciatore Demoniaco"] = "FR",
        ["Torre dei Maghi"] = "MT",
        ["Bandiera centrale"] = "MID",
        
        -- Battaglia per Gilneas
        ["Faro"] = "LH",
        ["Impianto Idrico"] = "WW",
        ["Miniere"] = "Mines",
        
        -- Isola della Conquista
        ["Darsena"] = "Docks",
        ["Officina"] = "Workshop",
        ["Hangar"] = "Hangar",
        ["Cava"] = "Quarry",
        ["Raffineria"] = "Refinery",
    },
    ruRU = {
        -- Низина Арати
        ["Стойла"] = "ST",
        ["Кузница"] = "BS",
        ["Лесопилка"] = "LM",
        ["Золотой рудник"] = "GM",
        ["Ферма"] = "Farm",
        
        -- Око Бури
        ["Башня Кровавых эльфов"] = "B11",
        ["Руины дренеев"] = "DR",
        ["Руины Скверноботов"] = "FR",
        ["Башня Магов"] = "BM",
        ["Центральный флаг"] = "MID",
        
        -- Битва за Гилнеас
        ["Маяк"] = "LH",
        ["Водоочистная станция"] = "WW",
        ["Рудник"] = "Mines",
        
        -- Остров Завоеваний
        ["Доки"] = "Docks",
        ["Мастерская"] = "Workshop",
        ["Ангар"] = "Hangar",
        ["Каменоломня"] = "Quarry",
        ["Нефтезавод"] = "Refinery",
    }
}

function addon:GetLocalizedText(key, ...)
    local lang = GetLocale()
    local text = (addon.L[lang] and addon.L[lang][key]) or addon.L["enUS"][key] or key
    return string.format(text, ...)
end

-- Return the addon table at the end of the file
return addon