-- Locale
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local AL = AceLocale:NewLocale("RareScanner", "itIT", false);

if AL then
	AL["ALARM_MESSAGE"] = "È appena apparso un PNG, controlla la mappa!"
	AL["ALARM_SOUND"] = "Suono di avviso per i PNG rari"
	AL["ALARM_SOUND_DESC"] = "Suono riprodotto quando un PNG raro appare nella minimappa"
	AL["ALARM_TREASURES_SOUND"] = "Suono di avviso per eventi/tesori"
	AL["ALARM_TREASURES_SOUND_DESC"] = "Suono riprodotto quando un tesoro/forziere o un evento appare nella minimappa"
	AL["ALL_ZONES"] = "Tutto"
	AL["AUTO_HIDE_BUTTON"] = "Nascondi automaticamente il pulsante e la miniatura"
	AL["AUTO_HIDE_BUTTON_DESC"] = "Nasconde automaticamente il pulsante e la miniatura dopo la durata stabilita (in secondi). Impostando una durata pari a zero secondi il pulsante e la miniatura non si nasconderanno automaticamente."
	AL["CLASS_HALLS"] = "Enclavi di Classe"
	AL["CLEAR_FILTERS_SEARCH"] = "Azzera"
	AL["CLEAR_FILTERS_SEARCH_DESC"] = "Ripristina il modulo allo stato iniziale"
	AL["CLICK_TARGET"] = "Fai clic per selezionare il PNG"
	AL["CMD_HELP1"] = "Lista dei comandi"
	AL["CMD_HELP2"] = "Mostra/nascondi tutte le icone della mappa globale"
	AL["CMD_HELP3"] = "Mostra/nascondi icone degli eventi della mappa globale"
	AL["CMD_HELP4"] = "Mostra/nascondi icone degli dei tesori della mappa globale"
	AL["CMD_HELP5"] = "Mostra/nascondi icone degli NPC rari nella mappa globale"
	AL["CMD_HELP6"] = "Attiva/disattiva tutti gli avvisi"
	AL["CMD_HELP7"] = "Attiva/disattiva gli avvisi degli eventi"
	AL["CMD_HELP8"] = "Attiva/disattiva gli avvisi dei tesori"
	AL["CMD_HELP9"] = "Attiva/disattiva gli avvisi degli NPC rari"
	AL["CONTAINER"] = "Contenitore"
	AL["DATABASE_HARD_RESET"] = "Poiché con l'espansione più recente e l'ultima versione di RareScanner si sono verificati grandi cambiamenti nel database, si è dovuti ricorrere a una reimpostazione del database per evitare incoerenze. Ci dispiace per l'inconveniente."
	AL["DISABLE_SEARCHING_RARE_TOOLTIP"] = "Disabilita gli avvisi per questo PNG raro"
	AL["DISABLE_SOUND"] = "Disabilita gli avvisi sonori con gli NPC"
	AL["DISABLE_SOUND_DESC"] = "Se attivato non riceverai alcun avviso sonoro"
	AL["DISABLED_SEARCHING_RARE"] = "Avvisi disabilitati per questo PNG raro:"
	AL["DISPLAY"] = "Visualizzazione"
	AL["DISPLAY_BUTTON"] = "Attiva/Disattiva la visualizzazione del pulsante e della miniatura"
	AL["DISPLAY_BUTTON_CONTAINERS"] = "Attiva/Disattiva la visualizzazione del pulsante per i tesori/forzieri"
	AL["DISPLAY_BUTTON_CONTAINERS_DESC"] = "Attiva/Disattiva la visualizzazione del pulsante per i tesori/forzieri. Non influisce sull'allarme sonoro e sugli avvisi della chat."
	AL["DISPLAY_BUTTON_DESC"] = "Se disattivato, il pulsante e la miniatura non verranno più mostrati. Non influisce sull'allarme sonoro e sugli avvisi della chat."
	AL["DISPLAY_LOOT_PANEL"] = "Attiva/Disattiva la barra del bottino"
	AL["DISPLAY_LOOT_PANEL_DESC"] = "Se attivata, apparirà una una barra con i bottini depredabili dal PNG trovato"
	AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS"] = "Attiva/Disattiva la visualizzazione delle icone non scoperte sulla mappa."
	AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS_DESC"] = "Se disattivate, le icone dei PNG rari non scoperti (le icone rosse e arancioni), i contenitori o gli eventi non verranno mostrati sulla mappa del mondo"
	AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS"] = "Attiva/Disattiva la visualizzazione delle icone non scoperte sulla mappa per le espansioni precedenti."
	AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS_DESC"] = "Se disattivate, le icone dei PNG rari non scoperti (le icone rosse e arancioni), i contenitori o gli eventi non verranno mostrati sulla mappa del mondo per le aree che appartengono alle espansioni precedenti."
	AL["DISPLAY_MINIATURE"] = "Attiva/Disattiva la visualizzazione della miniatura"
	AL["DISPLAY_MINIATURE_DESC"] = "Se disabilitata, la miniatura non verrà mostrata nuovamente."
	AL["DISPLAY_OPTIONS"] = "Opzioni di visualizzazione"
	AL["DUNGEONS_SCENARIOS"] = "Spedizioni/Scenari"
	AL["ENABLE_SCAN_CONTAINERS"] = "Attiva/Disattiva la ricerca di tesori o forzieri"
	AL["ENABLE_SCAN_CONTAINERS_DESC"] = "Se attivata, un avviso grafico verrà accompagnato da una riproduzione sonora ogniqualvolta un tesoro o un forziere apparirà nella minimappa"
	AL["ENABLE_SCAN_EVENTS"] = "Attiva/Disattiva ricerca eventi"
	AL["ENABLE_SCAN_EVENTS_DESC"] = "Se attivata, un avviso grafico verrà accompagnato da una riproduzione sonora ogniqualvolta un evento apparirà nella minimappa"
	AL["ENABLE_SCAN_GARRISON_CHEST"] = "Attiva/Disattiva ricerca tesoro guarnigione"
	AL["ENABLE_SCAN_GARRISON_CHEST_DESC"] = "Se attivata, un avviso grafico verrà accompagnato da una riproduzione sonora ogniqualvolta un forziere apparirà nella minimappa"
	AL["ENABLE_SCAN_IN_INSTANCE"] = "Attiva/Disattiva scansione nelle istanze"
	AL["ENABLE_SCAN_IN_INSTANCE_DESC"] = "Se attivata, l'add-on funzionerà come al solito quando sei dentro un'istanza (spedizione, incursione, ecc.)"
	AL["ENABLE_SCAN_ON_TAXI"] = "Attiva/Disattiva la scansione mentre si usa un trasporto"
	AL["ENABLE_SCAN_ON_TAXI_DESC"] = "Se attivata, l'add-on funzionerà come al solito mentre si utilizza un mezzo di trasporto (volo, barca, ecc.)"
	AL["ENABLE_SCAN_RARES"] = "Attiva/Disattiva la ricerca dei PNG rari"
	AL["ENABLE_SCAN_RARES_DESC"] = "Se attivata, un avviso grafico verrà accompagnato da una riproduzione sonora ogniqualvolta un PNG raro apparirà nella minimappa"
	AL["ENABLE_SEARCHING_RARE_TOOLTIP"] = "Abilita gli avvisi per questo PNG raro"
	AL["ENABLED_SEARCHING_RARE"] = "Avvisi abilitati per questo PNG raro:"
	AL["EVENT"] = "Evento"
	AL["FILTER"] = "Filtri PNG"
	AL["FILTER_CONTINENT"] = "Continente/Categoria"
	AL["FILTER_CONTINENT_DESC"] = "Nome continente o categoria"
	AL["FILTER_RARE_LIST"] = "Filtra ricerca per i PNG rari"
	AL["FILTER_RARE_LIST_DESC"] = "Attiva/Disattiva la ricerca per questo PNG raro. Se disattivato, non si riceverà alcun avviso quando verrà trovato questo PNG."
	AL["FILTER_ZONE"] = "Zona"
	AL["FILTER_ZONE_DESC"] = "Zona dentro un continente o categoria"
	AL["FILTER_ZONES_LIST"] = "Elenco zona"
	AL["FILTER_ZONES_LIST_DESC"] = "Attiva/Disattiva avvisi in questa zona. Se disattivato, non si riceverà alcun avviso quando un PNG raro, evento o tesoro verrà trovato in questa zona."
	AL["FILTERS"] = "Filtri PNG rari"
	AL["FILTERS_SEARCH"] = "Cerca"
	AL["FILTERS_SEARCH_DESC"] = "Digita il nome del PNG da filtrare nell'elenco qui in basso"
	AL["GENERAL_OPTIONS"] = "Opzioni generali"
	AL["JUST_SPAWNED"] = "%s è appena apparso. Controlla la mappa!"
	AL["LEFT_BUTTON"] = "Clic con il pulsante sinistro del mouse"
	AL["LOOT_CATEGORY_FILTERED"] = "Filtro abilitato per la categoria/sottocategoria: %s/%s. Puoi disabilitare questo filtro cliccando nuovamente sull'icona del bottino oppure dal menu dell'add-on RareScanner"
	AL["LOOT_CATEGORY_FILTERS"] = "Filtri categoria"
	AL["LOOT_CATEGORY_FILTERS_DESC"] = "Filtra il bottino mostrato per categoria"
	AL["LOOT_CATEGORY_NOT_FILTERED"] = "Filtro disabilitato per la categoria/sottocategoria: %s/%s"
	AL["LOOT_DISPLAY_OPTIONS"] = "Opzioni di visualizzazione"
	AL["LOOT_DISPLAY_OPTIONS_DESC"] = "Mostra le opzioni per la barra del bottino"
	AL["LOOT_FILTER_COLLECTED"] = "Filtra mascotte, cavalcature e giocattoli collezionati."
	AL["LOOT_FILTER_COLLECTED_DESC"] = "Se attivata, nella barra del bottino verranno mostrati solamente i giocattoli, le cavalcature e le mascotte non ancora collezionate. Questo filtro non influisce su altre tipologie di oggetti depredabili, in alcun modo."
	AL["LOOT_FILTER_NOT_EQUIPABLE"] = "Filtra oggetti non equipaggiabili"
	AL["LOOT_FILTER_NOT_EQUIPABLE_DESC"] = "Se disabilitato, armature e armi non equipaggiabili da questo personaggio non verranno mostrati nella barra del bottino. Questo filtro non influisce su altre tipologie di oggetti depredabili, in alcun modo."
	AL["LOOT_FILTER_NOT_TRANSMOG"] = "Mostra solamente armi e armature trasmogrificabili"
	AL["LOOT_FILTER_NOT_TRANSMOG_DESC"] = "Se attivata, nella barra del bottino verranno mostrate solamente le armature e le armi non ancora collezionate. Questo filtro non influisce su altre tipologie di oggetti depredabili, in alcun modo."
	AL["LOOT_FILTER_SUBCATEGORY_DESC"] = "Attiva/Disattiva la visualizzazione di questa tipologia di bottino dalla barra del bottino. Se disabilitata, qualunque oggetto appartenente a questa categoria non verrà mostrato nel bottino depredabile dal PNG raro trovato."
	AL["LOOT_FILTER_SUBCATEGORY_LIST"] = "Sottocategorie"
	AL["LOOT_ITEMS_PER_ROW"] = "Numero di oggetti per riga da mostrare"
	AL["LOOT_ITEMS_PER_ROW_DESC"] = "Imposta il numero di oggetti da mostrare per riga sulla barra del bottino. Se il numero è inferiore rispetto al valore massimo impostato, verranno mostrate più righe."
	AL["LOOT_MAIN_CATEGORY"] = "Categoria principale"
	AL["LOOT_MAX_ITEMS"] = "Numero di oggetti da mostrare"
	AL["LOOT_MAX_ITEMS_DESC"] = "Imposta il numero massimo di oggetti da mostrare sulla barra del bottino."
	AL["LOOT_MIN_QUALITY"] = "Qualità minima bottino"
	AL["LOOT_MIN_QUALITY_DESC"] = "Definisce la qualità minima del bottino da mostrare nella barra del bottino"
	AL["LOOT_OPTIONS"] = "Opzioni bottino"
	AL["LOOT_OTHER_FILTERS"] = "Altri filtri"
	AL["LOOT_OTHER_FILTERS_DESC"] = "Altri filtri"
	AL["LOOT_PANEL_OPTIONS"] = "Opzioni barra del bottino"
	AL["LOOT_SUBCATEGORY_FILTERS"] = "Filtri sottocategoria"
	AL["LOOT_TOOLTIP_POSITION"] = "Posizione didascalia bottino"
	AL["LOOT_TOOLTIP_POSITION_DESC"] = "Definisce dove mostrare la didascalia del bottino che appare quando si porta il cursore del mouse su un'icona rispetto al pulsante"
	AL["MAIN_BUTTON_OPTIONS"] = "Opzioni pulsante principale"
	AL["MAP_MENU_SHOW_NOT_DISCOVERED"] = "Entità non scoperte"
	AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"] = "Entità non scoperte (espansioni precedenti)"
	AL["MAP_NEVER"] = "Mai"
	AL["MAP_OPTIONS"] = "Opzioni mappa"
	AL["MAP_SHOW_ICON_AFTER_COLLECTED"] = "Continua a mostrare le icone del contenitore dopo il depredaggio"
	AL["MAP_SHOW_ICON_AFTER_COLLECTED_DESC"] = "Se disabilitato, l'icona scomparirà dopo aver depredato il contenitore."
	AL["MAP_SHOW_ICON_AFTER_DEAD"] = "Continua a mostrare le icone dei PNG dopo la morte"
	AL["MAP_SHOW_ICON_AFTER_DEAD_DESC"] = "Se disabilitate, le icone scompariranno dopo aver ucciso il PNG. L'icona riapparirà non appena il PNG diverrà nuovamente disponibile. Questa opzione funziona solamente con quei PNG che rimarranno rari nonostante la loro uccisione."
	AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME"] = "Durata per nascondere le icone dei contenitori (in minuti)"
	AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME_DESC"] = "Imposta la durata massima in minuti dal momento in cui il contenitore è stato visto. Dopo tale durata, l'icona non verrà mostrata più sulla mappa del mondo fin quando il contenitore non verrà trovato nuovamente. Impostando una durata pari a zero minuti le icone verranno mostrate a prescindere dalla durata impostata. Questo filtro non include i contenitori appartenenti a un'impresa."
	AL["MAP_SHOW_ICON_MAX_SEEN_TIME"] = "Timer per nascondere le icone degli NPC rari (in minuti)"
	AL["MAP_SHOW_ICON_MAX_SEEN_TIME_DESC"] = "Imposta la durata massima in ore dal momento in cui il PNG è stato visto. Dopo tale durata, l'icona non verrà mostrata più sulla mappa del mondo fin quando il PNG non verrà trovato nuovamente. Impostando una durata pari a zero minuti le icone verranno mostrate a prescindere dalla durata impostata."
	AL["MAP_TOOLTIP_ACHIEVEMENT"] = "È un obiettivo dell'impresa %s"
	AL["MAP_TOOLTIP_ALREADY_KILLED"] = "Questo PNG è stato già ucciso. Riprova in: %s"
	AL["MAP_TOOLTIP_ALREADY_OPENED"] = "Questo contenitore è stato già aperto. Riprova in: %s"
	AL["MAP_TOOLTIP_CONTAINER_LOOTED"] = "Alt + Maiusc + Clic con il pulsante sinistro del mouse per impostarlo come depredato."
	AL["MAP_TOOLTIP_DAYS"] = "giorni"
	AL["MAP_TOOLTIP_EVENT_DONE"] = "Alt + Maiusc + Clic con il pulsante sinistro del mouse per impostarlo come completato"
	AL["MAP_TOOLTIP_KILLED"] = "Alt + Maiusc + Clic con il pulsante sinistro del mouse per impostarlo come ucciso"
	AL["MAP_TOOLTIP_NOT_FOUND"] = "Non hai visto questo PNG e nessun altro l'ha condiviso ancora con te."
	AL["MAP_TOOLTIP_SEEN"] = "Visto prima: %s"
	AL["MAP_TOOLTIPS_LOOT"] = "Mostra il bottino nelle didascalie sulla mappa"
	AL["MAP_TOOLTIPS_LOOT_DESC"] = "Attiva/Disattiva la visualizzazione del bottino del PNG/contenitori nelle didascalie quando si porta il cursore del mouse sulle icone"
	AL["MESSAGE_OPTIONS"] = "Opzioni messaggi"
	AL["MIDDLE_BUTTON"] = "Clic con il pulsante centrale del mouse"
	AL["NOT_TARGETEABLE"] = "Non selezionabile"
	AL["NOTE_130350"] = "Devi cavalcare questo raro fino al contenitore che troverai seguendo il percorso sulla destra partendo da questa posizione."
	AL["NOTE_131453"] = "Devi cavalcare il [Guardiano della Primavera] fino a questa posizione. Il cavallo è un raro amichevole che troverai seguendo il percorso sulla sinistra partendo da questo contenitore."
	AL["NOTE_280951"] = "Segui la ferrovia fino a trovare un carrello. Guidalo per scoprire il tesoro."
	AL["NOTE_287239"] = "Se fai parte dell'Orda devi completare la campagna di Vol'dun per poter accedere al tempio."
	AL["NOTE_289647"] = "Il tesoro è in una caverna. L'ingresso è alle coordinate 65.11, tra alcuni alberi quasi in cima alla montagna."
	AL["NOTE_292673"] = "1 di 5 pergamene. Leggile tutte per scoprire il tesoro [Il Segreto degli Abissi]. È nel seminterrato. Nascondi questa icona manualmente dopo averla letta."
	AL["NOTE_292674"] = "2 di 5 pergamene. Leggile tutte per scoprire il tesoro [Il Segreto degli Abissi]. È sotto il pavimento di legno, nell'angolo accanto a un mazzo di candele. Nascondi questa icona manualmente dopo averla letta."
	AL["NOTE_292675"] = "3 di 5 pergamene. Leggile tutte per scoprire il tesoro [Il Segreto degli Abissi]. È  nel seminterrato. Nascondi questa icona manualmente dopo averla letta."
	AL["NOTE_292676"] = "4 di 5 pergamene. Leggile tutte per scoprire il tesoro [Il Segreto degli Abissi]. Si trova all'ultimo piano. Nascondi questa icona manualmente dopo averla letta."
	AL["NOTE_292677"] = "5 di 5 pergamene. Leggile tutte per scoprire il tesoro [Il Segreto degli Abissi]. È in una caverna sotterranea. L'ingresso è sott'acqua alle coordinate 72.40 (piscina d'acqua del monastero). Nascondi questa icona manualmente dopo averla letta."
	AL["NOTE_292686"] = "Dopo aver letto le 5 pergamene, usa l'[Altare Inquietante] per ottenere [Il Segreto degli Abissi]. Avvertenza: l'uso dell'altare ti teletrasporterà in mezzo al mare. Nascondi questa icona manualmente una volta utilizzato."
	AL["NOTE_293349"] = "È all'interno del capannone, in cima a uno scaffale."
	AL["NOTE_293350"] = "Questo tesoro è nascosto in fondo a una caverna. Dirigiti alle coordinate 61.38 e punta la telecamera verso l'alto, dopodiché salta all'indietro attraverso la piccola crepa sul pavimento e atterra sulla sporgenza."
	AL["NOTE_293852"] = "Non lo vedrai fin quando non avrai collezionato la [Mappa del Tesoro Inzuppata] dai pirati al Covo della Libertà"
	AL["NOTE_293880"] = "Non lo vedrai fin quando non avrai collezionato la [Mappa del Tesoro Sbiadita] dai pirati al Covo della Libertà"
	AL["NOTE_293881"] = "Non lo vedrai fin quando non avrai collezionato la [Mappa del Tesoro Ingiallita] dai pirati al Covo della Libertà"
	AL["NOTE_293884"] = "Non lo vedrai fin quando non avrai collezionato la [Mappa del Tesoro Bruciacchiata] dai pirati al Covo della Libertà"
	AL["NOTE_297828"] = "Il corvo che vola in cima ha la chiave. Uccidilo."
	AL["NOTE_297891"] = "Devi disabilitare le rune in questo ordine: Sinistra, Giù, Su, Destra"
	AL["NOTE_297892"] = "Devi disabilitare le rune in questo ordine: Sinistra, Destra, Giù, Su"
	AL["NOTE_297893"] = "Devi disabilitare le rune in questo ordine: Destra, Su, Sinistra, Giù"
	AL["PROFILES"] = "Profili"
	AL["RAIDS"] = "Incursioni"
	AL["SHOW_CHAT_ALERT"] = "Attiva/Disattiva la visualizzazione degli avvisi di chat"
	AL["SHOW_CHAT_ALERT_DESC"] = "Mostra un messaggio privato ogniqualvolta un tesoro, forziere o PNG viene trovato"
	AL["SHOW_RAID_WARNING"] = "Attiva/disattiva gli avvisi dei raid"
	AL["SHOW_RAID_WARNING_DESC"] = "Mostra un avviso del raid sullo schermo ogni volta che viene trovato un tesoro, un forziere o un PNG."
	AL["SOUND"] = "Suono"
	AL["SOUND_OPTIONS"] = "Opzioni del suono"
	AL["SOUND_VOLUME"] = "Volume"
	AL["SOUND_VOLUME_DESC"] = "Imposta il livello del volume sonoro"
	AL["TEST"] = "Avvia il Test"
	AL["TEST_DESC"] = "Premi il pulsante per mostrare un avviso di esempio. Puoi trascinare e rilasciare il pannello in un'altra posizione di propria preferenza."
	AL["TOC_NOTES"] = "Scanner Minimappa. Crea un avviso sonoro e grafico riportante una miniatura e un pulsante ogniqualvolta un PNG, tesoro, cassa o evento apparirà sulla minimappa"
	AL["TOGGLE_FILTERS"] = "Filtri"
	AL["TOGGLE_FILTERS_DESC"] = "Seleziona tutti i filtri contemporaneamente"
	AL["TOOLTIP_BOTTOM"] = "Lato Inferiore"
	AL["TOOLTIP_CURSOR"] = "Segui cursore"
	AL["TOOLTIP_LEFT"] = "Lato sinistro"
	AL["TOOLTIP_RIGHT"] = "Lato destro"
	AL["TOOLTIP_TOP"] = "Lato superiore"
	AL["UNKNOWN"] = "Sconosciuto"
	AL["UNKNOWN_TARGET"] = "Bersaglio sconosciuto"
	AL["ZONES_FILTER"] = "Filtri zone"
	AL["ZONES_FILTERS_SEARCH_DESC"] = "Digita il nome della zona da filtrare nell'elenco qui in basso"

	-- CONTINENT names
	AL["ZONES_CONTINENT_LIST"] = {
		[9999] = "Enclavi di Classe"; --Class Halls
		[9998] = "Isola di Lunacupa"; --Darkmoon Island
		[9997] = "Spedizioni/Scenari"; --Dungeons/Scenarios
		[9996] = "Incursioni"; --Raids
		[9995] = "Sconosciuto"; --Unknown
		[9994] = "Expedition islands"; --Expedition islands
	}
end