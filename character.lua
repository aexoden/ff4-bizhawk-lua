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
	criticalBonus          = {offset = 0x2E, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown2F              = {offset = 0x2F, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Equipment: 0x30 - 0x36
	exp                    = {offset = 0x37, f = memory.read_u24_le, mask = nil,  boolean = false},
	unknown3A              = {offset = 0x3A, f = memory.readbyte,    mask = nil,  boolean = false},
	speedModifier          = {offset = 0x3B, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown3C              = {offset = 0x3C, f = memory.readbyte,    mask = nil,  boolean = false},
	levelUpExp             = {offset = 0x3D, f = memory.read_u24_le, mask = nil,  boolean = false},
	-- TODO: Creature Types: 0x40
	baseCriticalRate       = {offset = 0x41, f = memory.readbyte,    mask = nil,  boolean = false},
	baseCriticalBonus      = {offset = 0x42, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown43              = {offset = 0x43, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown44              = {offset = 0x44, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown45              = {offset = 0x45, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown46              = {offset = 0x46, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown47              = {offset = 0x47, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown48              = {offset = 0x48, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown49              = {offset = 0x49, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4A              = {offset = 0x4A, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4B              = {offset = 0x4B, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4C              = {offset = 0x4C, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4D              = {offset = 0x4D, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4E              = {offset = 0x4E, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown4F              = {offset = 0x4F, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown50              = {offset = 0x50, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Next Command: 0x51
	-- TODO: Next Sub-Action: 0x52
	-- TODO: Next Action Monster Target: 0x53
	-- TODO: Next Action Party Target: 0x54
	unknown55              = {offset = 0x55, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown56              = {offset = 0x56, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown57              = {offset = 0x57, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown58              = {offset = 0x58, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown59              = {offset = 0x59, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5A              = {offset = 0x5A, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5B              = {offset = 0x5B, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5C              = {offset = 0x5C, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5D              = {offset = 0x5D, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5E              = {offset = 0x5E, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown5F              = {offset = 0x5F, f = memory.readbyte,    mask = nil,  boolean = false},
	relativeSpeed          = {offset = 0x60, f = memory.read_u16_le, mask = nil,  boolean = false},
	unknown62              = {offset = 0x62, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown63              = {offset = 0x63, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown64              = {offset = 0x64, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown65              = {offset = 0x65, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown66              = {offset = 0x66, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown67              = {offset = 0x67, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown68              = {offset = 0x68, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown69              = {offset = 0x69, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6A              = {offset = 0x6A, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6B              = {offset = 0x6B, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6C              = {offset = 0x6C, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6D              = {offset = 0x6D, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6E              = {offset = 0x6E, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown6F              = {offset = 0x6F, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Level and Boss Bit: 0x70
	unknown71              = {offset = 0x71, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown72              = {offset = 0x72, f = memory.readbyte,    mask = nil,  boolean = false},
	-- TODO: Item Byte: 0x73
	unknown74              = {offset = 0x74, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown75              = {offset = 0x75, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown76              = {offset = 0x76, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown77              = {offset = 0x77, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown78              = {offset = 0x78, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown79              = {offset = 0x79, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7A              = {offset = 0x7A, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7B              = {offset = 0x7B, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7C              = {offset = 0x7C, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7D              = {offset = 0x7D, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7E              = {offset = 0x7E, f = memory.readbyte,    mask = nil,  boolean = false},
	unknown7F              = {offset = 0x7F, f = memory.readbyte,    mask = nil,  boolean = false},

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

local UNKNOWN_BYTES = {
	0x2F, 0x3A, 0x3C, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
	0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50, 0x55, 0x56, 0x57, 0x58, 0x59,
	0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
	0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x71, 0x72, 0x74, 0x75,
	0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F
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
	drawText(16, 0, string.format('Critical Rate:  %d (%d base)', characterBattle.criticalRate, characterBattle.baseCriticalRate))
	drawText(17, 0, string.format('Critical Bonus: %d (%d base)', characterBattle.criticalBonus, characterBattle.baseCriticalBonus))

	local row = 19
	local col = 0

	for i = 1, #UNKNOWN_BYTES do
		local index = UNKNOWN_BYTES[i]
		local value = characterBattle[string.format('unknown%02X', index)]
		drawText(row, col, string.format('0x%02X: %3d', index, value))

		row = row + 1

		if row > 31 then
			row = 19
			col = col + 10
		end
	end
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
