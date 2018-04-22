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
	id     = {offset = 0x00, f = memory.readbyte,    mask = 0x1F, boolean = false},
	class  = {offset = 0x01, f = memory.readbyte,    mask = 0x0F, boolean = false},
	level  = {offset = 0x02, f = memory.readbyte,    mask = nil,  boolean = false},
	hp     = {offset = 0x07, f = memory.read_u16_le, mask = nil,  boolean = false},
	hp_max = {offset = 0x09, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp     = {offset = 0x0B, f = memory.read_u16_le, mask = nil,  boolean = false},
	mp_max = {offset = 0x0D, f = memory.read_u16_le, mask = nil,  boolean = false},
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

local function readCharacter(slot, battle)
	local character = {}

	for key, _ in pairs(STATS) do
		character[key] = readStat(key, slot, battle)
	end

	character.name = CHARACTERS[character.id]
	character.className = CLASSES[character.class]

	return character
end

local function drawText(row, col, text, color)
	gui.pixelText(256 + col * 4, row * 7, text, color)
end

local function displayCharacterData(slot)
	local characterBattle = readCharacter(slot, true)

	drawText(0, 0, string.format("Slot:      %d", slot))
	drawText(1, 0, string.format("Character: %s", characterBattle.name))
	drawText(2, 0, string.format("Class:     %s", characterBattle.className))
	drawText(3, 0, string.format("Level:     %d", characterBattle.level))
	drawText(4, 0, string.format("HP:        %d / %d", characterBattle.hp, characterBattle.hp_max))
	drawText(5, 0, string.format("MP:        %d / %d", characterBattle.mp, characterBattle.mp_max))
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
