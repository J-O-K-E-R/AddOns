if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end
if not DBM_COMMON_L then DBM_COMMON_L = {} end

local CL = DBM_COMMON_L

CL.NONE						= "Ninguno"
CL.RANDOM					= "Aleatorio"
CL.NEXT						= "Siguiente %s"
CL.COOLDOWN					= "%s TdR"
CL.UNKNOWN					= "Desconocido"--UNKNOWN which is "Unknown" (does u vs U matter?)
CL.LEFT						= "Izquierda"
CL.RIGHT						= "Derecha"
CL.BOTH						= "Ambos"
CL.BEHIND					= "Detrás"
CL.BACK						= "Atrás"--BACK
CL.SIDE						= "Lado"
CL.TOP						= "Arriba"
CL.BOTTOM					= "Abajo"
CL.MIDDLE					= "Medio"
CL.FRONT						= "Delante"
CL.EAST						= "Este"
CL.WEST						= "Oeste"
CL.NORTH						= "Norte"
CL.SOUTH						= "Sur"
CL.INTERMISSION				= "Interfase"--No blizz global for this, and will probably be used in most end tier fights with intermission phases
CL.ORB						= "Orbe"
CL.ORBS						= "Orbes"
CL.CHEST						= "Cofre"--As in Treasure 'Chest'. Not Chest as in body part.
CL.NO_DEBUFF					= "Sin %s"--For use in places like info frame where you put "Not Spellname"
CL.ALLY						= "un aliado"--Such as "Move to Ally"
CL.ALLIES					= "tus aliados"--Such as "Move to Allies"
CL.ADD						= "Esbirro"--A fight Add as in "boss spawned extra adds" - must check
CL.ADDS						= "Esbirros"
CL.BIG_ADD					= "Esbirro grande"
CL.BOSS						= "Jefe"
CL.EDGE						= "los bordes de la sala"
CL.FAR_AWAY					= "alejarte"
CL.BREAK_LOS					= "romper la línea de mira"
CL.RESTORE_LOS				= "la línea de mira"
CL.SAFE						= "Zona segura"
CL.NOTSAFE					= "Zona no segura"
CL.SHIELD					= "Escudo"
CL.PILLAR					= "Pilar"
CL.INCOMING					= "%s en breve"
CL.BOSSTOGETHER				= "Jefes juntos"
CL.BOSSAPART					= "Jefes separados"