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
	id           = {offset = 0x00, f = memory.readbyte,    mask = 0x1F, boolean = false},
	leftHanded   = {offset = 0x00, f = memory.readbyte,    mask = 0x40, boolean = true},
	rightHanded  = {offset = 0x00, f = memory.readbyte,    mask = 0x80, boolean = true},
	class        = {offset = 0x01, f = memory.readbyte,    mask = 0x0F, boolean = false},
	inBackRow    = {offset = 0x01, f = memory.readbyte,    mask = 0x80, boolean = true},
	level        = {offset = 0x02, f = memory.readbyte,    mask = nil,  boolean = false},
	hp           = {offset = 0x07, f = memory.read_u16_le, mask = nil,  boolean = false},
	hp_max       = {offset = 0x09, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp           = {offset = 0x0B, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp_max       = {offset = 0x0D, f = memory.read_u16_le, mask = nil,  boolean = false},
	str_base     = {offset = 0x0F, f = memory.readbyte,    mask = nil,  boolean = false},
	agi_base     = {offset = 0x10, f = memory.readbyte,    mask = nil,  boolean = false},
	vit_base     = {offset = 0x11, f = memory.readbyte,    mask = nil,  boolean = false},
	wis_base     = {offset = 0x12, f = memory.readbyte,    mask = nil,  boolean = false},
	wil_base     = {offset = 0x13, f = memory.readbyte,    mask = nil,  boolean = false},
	str          = {offset = 0x14, f = memory.readbyte,    mask = nil,  boolean = false},
	agi          = {offset = 0x15, f = memory.readbyte,    mask = nil,  boolean = false},
	vit          = {offset = 0x16, f = memory.readbyte,    mask = nil,  boolean = false},
	wis          = {offset = 0x17, f = memory.readbyte,    mask = nil,  boolean = false},
	wil          = {offset = 0x18, f = memory.readbyte,    mask = nil,  boolean = false},

	unknownFlagA = {offset = 0x00, f = memory.readbyte,    mask = 0x20, boolean = true},
	unknownFlagB = {offset = 0x01, f = memory.readbyte,    mask = 0x10, boolean = true},
	unknownFlagC = {offset = 0x01, f = memory.readbyte,    mask = 0x20, boolean = true},
	unknownFlagD = {offset = 0x01, f = memory.readbyte,    mask = 0x40, boolean = true},
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

	character.flags = formatFlagString(FLAGS, character)
	character.unknownFlags = formatFlagString(UNKNOWN_FLAGS, character)

	return character
end

local function drawText(row, col, text, color, backcolor)
	gui.pixelText(256 + col * 4, row * 7, text, color, backcolor)
end

local function displayCharacterData(slot)
	local characterBattle = readCharacter(slot, true)

	drawText(0, 0, string.format('Slot:       %d', slot))
	drawText(1, 0, string.format('Character:  %s', characterBattle.name))
	drawText(2, 0, string.format('Class:      %s', characterBattle.className))
	drawText(3, 12, 'LRB', 0xFF606060)
	drawText(3, 0, string.format('Flags:      %s', characterBattle.flags), nil, 0x00000000)
	drawText(4, 12, 'ABCD', 0xFF606060)
	drawText(4, 0, string.format('? Flags:    %s', characterBattle.unknownFlags), nil, 0x00000000)
	drawText(5, 0, string.format('Level:      %d', characterBattle.level))
	drawText(6, 0, string.format('HP:         %d / %d', characterBattle.hp, characterBattle.hp_max))
	drawText(7, 0, string.format('MP:         %d / %d', characterBattle.mp, characterBattle.mp_max))
	drawText(8, 0, string.format('Base Stats: %s', characterBattle.stats_base))
	drawText(9, 0, string.format('Stats:      %s', characterBattle.stats))
end

--------------------------------------------------------------------------------
-- Main Execution
--------------------------------------------------------------------------------

function main()
	client.SetGameExtraPadding(0, 0, 256, 0)
	displayCharacterData(0)
end

while true do
	main()
	emu.frameadvance()
end
