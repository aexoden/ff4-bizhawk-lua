--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local CHARACTERS = {
	[0x00] = '<empty>',
	[0x01] = 'Dark Knight Cecil',
	[0x02] = 'Kain 1',
	[0x03] = 'Young Rydia',
	[0x04] = 'Tellah 1',
	[0x05] = 'Edward',
	[0x06] = 'Rosa 1',
	[0x07] = 'Yang 1',
	[0x08] = 'Palom',
	[0x09] = 'Porom',
	[0x0A] = 'Tellah 2',
	[0x0B] = 'Paladin Cecil',
	[0x0C] = 'Tellah 3',
	[0x0D] = 'Yang 2',
	[0x0E] = 'Cid',
	[0x0F] = 'Kain 2',
	[0x10] = 'Rosa 2',
	[0x11] = 'Adult Rydia',
	[0x12] = 'Edge',
	[0x13] = 'FuSoYa',
	[0x14] = 'Kain 3',
	[0x15] = 'Golbez',
	[0x16] = 'Anna',
}

local CLASSES = {
	[0x00] = 'Dark Knight',
	[0x01] = 'Dragoon',
	[0x02] = 'Caller',
	[0x03] = 'Sage',
	[0x04] = 'Bard',
	[0x05] = 'White Wizard (Rosa)',
	[0x06] = 'Karate',
	[0x07] = 'Black Wizard',
	[0x08] = 'White Wizard (Porom)',
	[0x09] = 'Paladin',
	[0x0A] = 'Chief',
	[0x0B] = 'Caller',
	[0x0C] = 'Ninja',
	[0x0D] = 'Lunar',
	[0x0E] = 'Golbez',
}

--------------------------------------------------------------------------------
-- Stat Definitions
--------------------------------------------------------------------------------

local STATS = {
	id                     = {offset = 0x00, f = memory.readbyte,    mask = 0x1F, boolean = false},
	leftHanded             = {offset = 0x00, f = memory.readbyte,    mask = 0x40, boolean = true},
	rightHanded            = {offset = 0x00, f = memory.readbyte,    mask = 0x80, boolean = true},
	class                  = {offset = 0x01, f = memory.readbyte,    mask = 0x0F, boolean = false},
	inBackRow              = {offset = 0x01, f = memory.readbyte,    mask = 0x80, boolean = true},
	level                  = {offset = 0x02, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Status Bytes: 0x03 - 0x06
	hp                     = {offset = 0x07, f = memory.read_u16_le, mask = nil,  boolean = false},
	hp_max                 = {offset = 0x09, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp                     = {offset = 0x0B, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp_max                 = {offset = 0x0D, f = memory.read_u16_le, mask = nil,  boolean = false},
	str_base               = {offset = 0x0F, f = memory.readbyte,    mask = nil,  boolean = false},
	agi_base               = {offset = 0x10, f = memory.readbyte,    mask = nil,  boolean = false},
	vit_base               = {offset = 0x11, f = memory.readbyte,    mask = nil,  boolean = false},
	wis_base               = {offset = 0x12, f = memory.readbyte,    mask = nil,  boolean = false},
	wil_base               = {offset = 0x13, f = memory.readbyte,    mask = nil,  boolean = false},
	str                    = {offset = 0x14, f = memory.readbyte,    mask = nil,  boolean = false},
	agi                    = {offset = 0x15, f = memory.readbyte,    mask = nil,  boolean = false},
	vit                    = {offset = 0x16, f = memory.readbyte,    mask = nil,  boolean = false},
	wis                    = {offset = 0x17, f = memory.readbyte,    mask = nil,  boolean = false},
	wil                    = {offset = 0x18, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Attack Elemental: 0x19
	-- TODO: Attack Races: 0x1A
	attackMultiplier       = {offset = 0x1B, f = memory.readbyte,    mask = nil,  boolean = false},
	attackPercent          = {offset = 0x1C, f = memory.readbyte,    mask = nil,  boolean = false},
	attackBase             = {offset = 0x1D, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Attack Status: 0x1E - 0x1F
	-- TODO: Element Weakness: 0x20 - 0x21
	magicDefenseMultiplier = {offset = 0x22, f = memory.readbyte,    mask = nil,  boolean = false},
	magicDefensePercent    = {offset = 0x23, f = memory.readbyte,    mask = nil,  boolean = false},
	magicDefenseBase       = {offset = 0x24, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Elemental Defense: 0x25 - 0x26
	-- TODO: Racial Defense: 0x27
	defenseMultiplier      = {offset = 0x28, f = memory.readbyte,    mask = nil,  boolean = false},
	defensePercent         = {offset = 0x29, f = memory.readbyte,    mask = nil,  boolean = false},
	defenseBase            = {offset = 0x2A, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Status Immunity: 0x2B - 0x2C
	criticalRate           = {offset = 0x2D, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Unknown: 0x2E - 0x2F
	-- TODO: Equipment: 0x30 - 0x36
	exp                    = {offset = 0x37, f = memory.read_u24_le, mask = nil,  boolean = false},
	-- TODO: Unknown: 0x3A
	speedModifier          = {offset = 0x3B, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Unknown: 0x3C
	levelUpExp             = {offset = 0x3D, f = memory.read_u24_le, mask = nil,  boolean = false},
	-- TODO: Creature Types: 0x40
	-- TODO: Unknown: 0x41
	criticalBonus          = {offset = 0x42, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Unknown: 0x43 - 0x50
	-- TODO: Next Command: 0x51
	-- TODO: Next Sub-Action: 0x52
	-- TODO: Next Action Monster Target: 0x53
	-- TODO: Next Action Party Target: 0x54
	-- TODO: Unknown: 0x55 - 0x5F
	relativeSpeed          = {offset = 0x60, f = memory.read_u16_le, mask = nil,  boolean = false},
	-- TODO: Unknown: 0x62 - 0x6F
	-- TODO: Level and Boss Bit: 0x70
	-- TODO: Unknown: 0x71 - 0x72
	-- TODO: Item Byte: 0x73
	-- TODO: Unknown: 0x74 - 0x7F

	unknownFlagA           = {offset = 0x00, f = memory.readbyte,    mask = 0x20, boolean = true},
	unknownFlagB           = {offset = 0x01, f = memory.readbyte,    mask = 0x10, boolean = true},
	unknownFlagC           = {offset = 0x01, f = memory.readbyte,    mask = 0x20, boolean = true},
	unknownFlagD           = {offset = 0x01, f = memory.readbyte,    mask = 0x40, boolean = true},
}

local FLAGS = {
	{'leftHanded', 'L'},
	{'rightHanded', 'R'},
	{'inBackRow', 'B'},
}

local UNKNOWN_FLAGS = {
	{'unknownFlagA', 'A'},
	{'unknownFlagB', 'B'},
	{'unknownFlagC', 'C'},
	{'unknownFlagD', 'D'},
}

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

local function readStat(stat, slot, battle)
	local baseAddress = 0x1000 + slot * 0x40

	if battle then
		baseAddress = 0x2000 + slot * 0x80
	end

	local stat = STATS[stat]

	if stat.offset >= 0x40 and not battle then
		return nil
	end

	local value = stat.f(baseAddress + stat.offset)

	if stat.mask then
		value = bit.band(value, stat.mask)
	end

	if stat.boolean then
		value = value > 0
	end

	return value
end

local function formatFlagString(flags, character)
	local output = ''

	for i = 1, #flags do
		local flag, description = unpack(flags[i])

		if character[flag] then
			output = output .. description
		else
			output = output .. ' '
		end
	end

	return output
end

local function readCharacter(slot, battle)
	local character = {}

	for key, _ in pairs(STATS) do
		character[key] = readStat(key, slot, battle)
	end

	character.name = CHARACTERS[character.id]
	character.className = CLASSES[character.class]
	character.stats_base = string.format('%02d %02d %02d %02d %02d', character.str_base, character.agi_base, character.vit_base, character.wis_base, character.wil_base)
	character.stats = string.format('%02d %02d %02d %02d %02d', character.str, character.agi, character.vit, character.wis, character.wil)
	character.attack = string.format('%dx %d (%d%%)', character.attackMultiplier, character.attackBase, character.attackPercent)
	character.defense = string.format('%dx %d (%d%%)', character.defenseMultiplier, character.defenseBase, character.defensePercent)
	character.magicDefense = string.format('%dx %d (%d%%)', character.magicDefenseMultiplier, character.magicDefenseBase, character.magicDefensePercent)

	character.flags = formatFlagString(FLAGS, character)
	character.unknownFlags = formatFlagString(UNKNOWN_FLAGS, character)

	return character
end

local function drawText(row, col, text, color, backcolor)
	gui.pixelText(256 + col * 4, row * 7, text, color, backcolor)
end

local function displayCharacterData(slot)
	local characterBattle = readCharacter(slot, true)

	drawText( 0, 0, string.format('Slot:           %d', slot))
	drawText( 1, 0, string.format('Character:      %s', characterBattle.name))
	drawText( 2, 0, string.format('Class:          %s', characterBattle.className))
	drawText( 3, 16, 'LRB', 0xFF606060)
	drawText( 3, 0, string.format('Flags:          %s', characterBattle.flags), nil, 0x00000000)
	drawText( 4, 16, 'ABCD', 0xFF606060)
	drawText( 4, 0, string.format('? Flags:        %s', characterBattle.unknownFlags), nil, 0x00000000)
	drawText( 5, 0, string.format('Level:          %d', characterBattle.level))
	drawText( 6, 0, string.format('HP:             %d / %d', characterBattle.hp, characterBattle.hp_max))
	drawText( 7, 0, string.format('MP:             %d / %d', characterBattle.mp, characterBattle.mp_max))
	drawText( 8, 0, string.format('Base Stats:     %s', characterBattle.stats_base))
	drawText( 9, 0, string.format('Stats:          %s', characterBattle.stats))
	drawText(10, 0, string.format('Attack:         %s', characterBattle.attack))
	drawText(11, 0, string.format('Defense:        %s', characterBattle.defense))
	drawText(12, 0, string.format('Magic Defense:  %s', characterBattle.magicDefense))
	drawText(13, 0, string.format('Experience:     %d (%d to level up)', characterBattle.exp, characterBattle.levelUpExp))
	drawText(14, 0, string.format('Speed Modifier: %d', characterBattle.speedModifier))
	drawText(15, 0, string.format('Relative Speed: %d', characterBattle.relativeSpeed))
	drawText(16, 0, string.format('Critical Rate:  %d', characterBattle.criticalRate))
	drawText(17, 0, string.format('Critical Bonus: %d', characterBattle.criticalBonus))
end

--------------------------------------------------------------------------------
-- Form Handling
--------------------------------------------------------------------------------

local form
local formLabel
local formSlot
local formButton

local slot = 0

function onExit()
	forms.destroy(form)
end

function onUpdate()
	slot = tonumber(forms.gettext(formSlot))
end

form = forms.newform(200, 150, "Character Record")
formLabel = forms.label(form, 'Slot to Display:', 5, 8)
formSlot = forms.textbox(form, '0', 170, 25, nil, 5, 32)
formButton = forms.button(form, 'Update', onUpdate, 5, 64)

event.onexit(onExit)

--------------------------------------------------------------------------------
-- Main Execution
--------------------------------------------------------------------------------

function main()
	client.SetGameExtraPadding(0, 0, 256, 0)
	displayCharacterData(slot)
end

while true do
	main()
	emu.frameadvance()
end
