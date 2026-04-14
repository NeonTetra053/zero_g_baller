extends Node2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_GREEN, COIN, BOOSTER, EXP, ENEMY_YELLOW, ENEMY_RED, PLANET
}
const MIN_X = 0
const MAX_X = 9
const TILE_SIZE = 32
const MOVE_TIME = 0.5
const GRID_W := 10
const GRID_H := 18
var hit_streak = 0
# -1 = empty
# >= 0 = BrickType
var grid = []
var stage_gen = {
	1: {
		"layout": [
			{ "pos": Vector2(2, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(3, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(4.5, 6), "type": BrickType.COIN }
		],
		"waves": [
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 4), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 9), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
		]
	},

	2: {
		"layout": [
			{ "pos": Vector2(0, 4), "type": BrickType.COIN },
			{ "pos": Vector2(9, 4), "type": BrickType.COIN },
			{ "pos": Vector2(1, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(3, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(4.5, 6), "type": BrickType.COIN },
			{ "pos": Vector2(3, 11), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 11), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(5, 1), "type": BrickType.YELLOW }
		],
		"waves": [
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 2), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(5, 2), "type": BrickType.ENEMY_YELLOW }
			],
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 2), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(5, 2), "type": BrickType.ENEMY_YELLOW }
			],
			[
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 1), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 2), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 2), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 6), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,1,0,0,0,0],
			[1,1,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},
	3: {
		"layout": [
			{ "pos": Vector2(2, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(4.5, 5), "type": BrickType.COIN },
			{ "pos": Vector2(1, 6), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 6), "type": BrickType.YELLOW }
		],
		"waves": [
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 4), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 4), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	4: {
		"layout": [
			{ "pos": Vector2(1, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(5, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(4.5, 4), "type": BrickType.COIN },
		],
		"waves": [
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 6), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	5: {
		"layout": [
			{ "pos": Vector2(0, 10), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 10), "type": BrickType.COIN },
			{ "pos": Vector2(2, 10), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 10), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 10), "type": BrickType.COIN },
			{ "pos": Vector2(9, 10), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 15), "type": BrickType.RED },
			{ "pos": Vector2(9, 15), "type": BrickType.GREEN },
			{ "pos": Vector2(2, 3), "type": BrickType.PURPLE },
			{ "pos": Vector2(7, 3), "type": BrickType.PURPLE },
			{ "pos": Vector2(4.5, 5), "type": BrickType.COIN },
		],
		"waves": [
			[
				{ "pos": Vector2(4, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 8), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 3), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 6), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	6: {
		"layout": [
			{ "pos": Vector2(3, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(5, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 4), "type": BrickType.RED },
			{ "pos": Vector2(8, 4), "type": BrickType.GREEN },
			{ "pos": Vector2(4.5, 9), "type": BrickType.COIN },
			{ "pos": Vector2(4.5, 4), "type": BrickType.EXP },
			{ "pos": Vector2(0, 12), "type": BrickType.GREEN },
			{ "pos": Vector2(9, 12), "type": BrickType.RED },
			{ "pos": Vector2(3, 14), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 14), "type": BrickType.YELLOW },
			{ "pos": Vector2(5, 14), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 14), "type": BrickType.YELLOW },
		],
		"waves": [
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 7), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	7: {
		"layout": [
			{ "pos": Vector2(2, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(7, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(3, 6), "type": BrickType.YELLOW },
			{ "pos": Vector2(6, 6), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 8), "type": BrickType.RED },
			{ "pos": Vector2(9, 8), "type": BrickType.GREEN },
			{ "pos": Vector2(4.5, 11), "type": BrickType.COIN },
			{ "pos": Vector2(0, 14), "type": BrickType.PURPLE },
			{ "pos": Vector2(9, 14), "type": BrickType.PURPLE },
		],
		"waves": [
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 4), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 1), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	8: {
		"layout": [
			{ "pos": Vector2(2, 3), "type": BrickType.GREEN },
			{ "pos": Vector2(7, 3), "type": BrickType.RED },
			{ "pos": Vector2(0, 7), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 7), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 7), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 7), "type": BrickType.YELLOW },
			{ "pos": Vector2(4.5, 8), "type": BrickType.COIN },
			{ "pos": Vector2(2, 11), "type": BrickType.PURPLE },
			{ "pos": Vector2(7, 11), "type": BrickType.PURPLE },
		],
		"waves": [
			[
				{ "pos": Vector2(3, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 10), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 8), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(3, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 6), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	9: {
		"layout": [
			{ "pos": Vector2(4.5, 13), "type": BrickType.BOOSTER },
			{ "pos": Vector2(4.5, 13), "type": BrickType.COIN },
			{ "pos": Vector2(1, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(5, 2), "type": BrickType.PURPLE },
			{ "pos": Vector2(4.5, 4), "type": BrickType.COIN },
			{ "pos": Vector2(3, 8), "type": BrickType.COIN },
			{ "pos": Vector2(6, 8), "type": BrickType.COIN },
		],
		"waves": [
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 4), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 4), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1,0,0,0,0,0],
			[1,0,0,0,0,0],
			[1,1,0,0,0,0],
		]
	},

	10: {
		"layout": [
			{ "pos": Vector2(1, 3), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(2, 2), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(3, 1), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(0, 4), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(0, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 4), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(8, 3), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(7, 2), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(6, 1), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(9, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(4.5, 5), "type": BrickType.BLUE },
			{ "pos": Vector2(4.5, 9), "type": BrickType.BLUE },
			{ "pos": Vector2(4.5, 13), "type": BrickType.BLUE },
			{ "pos": Vector2(4.5, 17), "type": BrickType.BLUE },
			{ "pos": Vector2(2, 9), "type": BrickType.BOOSTER },
			{ "pos": Vector2(7, 9), "type": BrickType.BOOSTER },
		],
		"waves": [
			[
				{ "pos": Vector2(5, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(9, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4.5, 7), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(5, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(9, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 5), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_GREEN },
			]
		],
		"cannon_arrays": [
			[1,1,0,0,0,0],
			[1,1,1,0,0,0],
			[1,1,1,0,0,0],
		]
	},

	11: {
		"layout": [
			{ "pos": Vector2(0, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 8), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 8), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 12), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 12), "type": BrickType.YELLOW },
			{ "pos": Vector2(5, 7), "type": BrickType.PLANET },
		],
		"waves": [
			[
				{ "pos": Vector2(0, 3), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(9, 3), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(1, 1), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(9, 1), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN }
			],
			[
				{ "pos": Vector2(4.5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 6), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 6), "type": BrickType.ENEMY_GREEN }
			]
		],
		"cannon_arrays": [
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
		]
	},

	12: {
		"layout": [
			{ "pos": Vector2(0, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 4), "type": BrickType.COIN },
			{ "pos": Vector2(1, 6), "type": BrickType.RED },
			{ "pos": Vector2(8, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 4), "type": BrickType.GREEN },
			{ "pos": Vector2(5, 7), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(6, 6), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(4.5, 9), "type": BrickType.COIN },
			{ "pos": Vector2(2, 11), "type": BrickType.PURPLE },
			{ "pos": Vector2(7, 13), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 15), "type": BrickType.BOOSTER },
			{ "pos": Vector2(1, 14), "type": BrickType.EXP },
		],
		"waves": [
			[
				{ "pos": Vector2(4, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 10), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 7), "type": BrickType.ENEMY_YELLOW },
			],
			[
				{ "pos": Vector2(2, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 7), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(6, 7), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(0, 5), "type": BrickType.ENEMY_GREEN },
			],
		],
		"cannon_arrays": [
			[1, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
		]
	},

	13: {
		"layout": [
			{ "pos": Vector2(0, 1), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(1, 2), "type": BrickType.ORANGE_1 },
			{ "pos": Vector2(2, 3), "type": BrickType.YELLOW },
			{ "pos": Vector2(9, 2), "type": BrickType.COIN },
			{ "pos": Vector2(8, 5), "type": BrickType.PURPLE },
			{ "pos": Vector2(1, 8), "type": BrickType.GREEN },
			{ "pos": Vector2(6, 8), "type": BrickType.RED },
			{ "pos": Vector2(3, 10), "type": BrickType.BLUE },
			{ "pos": Vector2(4.5, 6), "type": BrickType.COIN },
			{ "pos": Vector2(0, 12), "type": BrickType.YELLOW },
			{ "pos": Vector2(1, 13), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 14), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(8, 15), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(5, 16), "type": BrickType.BOOSTER },
		],
		"waves": [
			[
				{ "pos": Vector2(5, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 10), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(4, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(2, 6), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(3, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(9, 8), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(5, 7), "type": BrickType.ENEMY_GREEN },
			],
		],
		"cannon_arrays": [
			[1, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
			[1, 1, 1, 0, 0, 0],
		]
	},

	14: {
		"layout": [
			{ "pos": Vector2(1, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 4), "type": BrickType.YELLOW },
			{ "pos": Vector2(3, 4), "type": BrickType.COIN },
			{ "pos": Vector2(6, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(7, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(8, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(0, 8), "type": BrickType.PURPLE },
			{ "pos": Vector2(9, 9), "type": BrickType.RED },
			{ "pos": Vector2(4.5, 11), "type": BrickType.COIN },
			{ "pos": Vector2(2, 13), "type": BrickType.GREEN },
			{ "pos": Vector2(5, 14), "type": BrickType.EXP },
			{ "pos": Vector2(8, 12), "type": BrickType.YELLOW },
			{ "pos": Vector2(3, 16), "type": BrickType.BOOSTER },
		],
		"waves": [
			[
				{ "pos": Vector2(4.5, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 9), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 6), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(2, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(4, 7), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(9, 6), "type": BrickType.ENEMY_YELLOW },
			],
		],
		"cannon_arrays": [
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
		]
	},

	15: {
		"layout": [
			{ "pos": Vector2(0, 3), "type": BrickType.GREEN },
			{ "pos": Vector2(2, 1), "type": BrickType.YELLOW },
			{ "pos": Vector2(3, 2), "type": BrickType.YELLOW },
			{ "pos": Vector2(4, 3), "type": BrickType.COIN },
			{ "pos": Vector2(7, 2), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(8, 3), "type": BrickType.ORANGE_2 },
			{ "pos": Vector2(9, 5), "type": BrickType.YELLOW },
			{ "pos": Vector2(5, 6), "type": BrickType.PURPLE },
			{ "pos": Vector2(1, 9), "type": BrickType.BLUE },
			{ "pos": Vector2(8, 10), "type": BrickType.RED },
			{ "pos": Vector2(4.5, 12), "type": BrickType.COIN },
			{ "pos": Vector2(6, 14), "type": BrickType.YELLOW },
			{ "pos": Vector2(2, 15), "type": BrickType.BOOSTER },
			{ "pos": Vector2(9, 16), "type": BrickType.EXP },
		],
		"waves": [
			[
				{ "pos": Vector2(5, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(3, 7), "type": BrickType.ENEMY_GREEN },
			],
			[
				{ "pos": Vector2(4, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(8, 7), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(1, 8), "type": BrickType.ENEMY_YELLOW },
			],
			[
				{ "pos": Vector2(2, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(5, 10), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(7, 8), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(9, 9), "type": BrickType.ENEMY_GREEN },
				{ "pos": Vector2(0, 6), "type": BrickType.ENEMY_YELLOW },
				{ "pos": Vector2(4.5, 6), "type": BrickType.ENEMY_YELLOW },
			],
		],
		"cannon_arrays": [
			[1, 1, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0],
			[1, 1, 1, 0, 0, 0],
		]
	},
}
var stage = 1
var collected_coins := 0
var current_wave := 0
var total_waves := 0
var brick_scenes = [preload("res://scenes/brick_red_1.tscn"), preload("res://scenes/brick_purple_1.tscn"), preload("res://scenes/brick_yellow_1.tscn"), preload("res://scenes/brick_green_1.tscn"), preload("res://scenes/brick_blue_1.tscn"), preload("res://scenes/brick_orange_1.tscn"), preload("res://scenes/brick_orange_2.tscn"), preload("res://scenes/enemy_green.tscn"), preload("res://scenes/coin.tscn"), preload("res://scenes/booster.tscn"), preload("res://scenes/exp_object.tscn"), preload("res://scenes/enemy_yellow.tscn"), preload("res://scenes/planet.tscn"), preload("res://scenes/planet.tscn")]
var gameref
func set_gameref(new_gameref):
	gameref = new_gameref
func generate(number):
	for child in get_children():
		child.queue_free()
	init_grid()
	stage = number
	collected_coins = 0
	current_wave = 0

	var data = stage_gen[number]
	total_waves = data.waves.size()

	# 1. Spawn layout (NO enemies)
	for item in data.layout:
		spawn_brick(item)

	# 2. Spawn first wave
	spawn_wave()

	$"../../ui/ui_top_bar".set_level_label(number)
func clear_level():
	for child in get_children():
		child.queue_free()
func init_grid():
	grid.clear()
	for y in range(GRID_H):
		var row := []
		for x in range(GRID_W):
			row.append(-1)
		grid.append(row)
func spawn_brick(data):
	var grid_pos: Vector2i = Vector2i(data.pos)
	var brick = brick_scenes[data.type].instantiate()
	add_child(brick)

	brick.grid_pos = grid_pos
	brick.brick_type = data.type
	brick.position = grid_to_world(grid_pos)

	for tile in get_occupied_tiles(grid_pos, data.type):
		# Only write to grid if the tile is inside bounds
		if tile.x >= 0 and tile.x < GRID_W and tile.y >= 0 and tile.y < GRID_H:
			grid[tile.y][tile.x] = data.type

	if data.type == BrickType.ENEMY_GREEN:
		brick.set_meta("moving", false)
func grid_to_world(grid_pos: Vector2) -> Vector2:
	return grid_pos * TILE_SIZE + Vector2(16,16)

func in_bounds(p: Vector2) -> bool:
	return p.x >= 0 and p.x < GRID_W and p.y >= 0 and p.y < GRID_H
func spawn_wave():
	if current_wave >= total_waves:
		return
		sync_grid_to_children()
	gameref.cannon._reset_camera()
	var cannon_array = stage_gen[stage].cannon_arrays[current_wave]
	get_parent().cannon.set_cannon(cannon_array)
	var wave = stage_gen[stage].waves[current_wave]
	current_wave += 1

	for enemy_data in wave:
		spawn_brick(enemy_data)
		
func get_occupied_tiles(grid_pos: Vector2i, brick_type: int) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []

	match brick_type:
		BrickType.YELLOW, BrickType.ORANGE_1, BrickType.ORANGE_2:
			tiles.append(grid_pos)

		BrickType.PURPLE:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2i(-1, 0))
			tiles.append(grid_pos + Vector2i(1, 0))

		BrickType.RED:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2i(0, 1))
			tiles.append(grid_pos + Vector2i(1, 1))

		BrickType.GREEN:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2i(0, 1))
			tiles.append(grid_pos + Vector2i(-1, 1))

		BrickType.BLUE:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2i(0, 1))
			tiles.append(grid_pos + Vector2i(0, 2))
			tiles.append(grid_pos + Vector2i(0, 3))

		BrickType.PLANET:
			tiles.append(grid_pos)
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					tiles.append(grid_pos + Vector2i(dx, dy))

		BrickType.ENEMY_GREEN, BrickType.ENEMY_YELLOW, BrickType.ENEMY_RED:
			tiles.append(grid_pos)

	return tiles
	
func build_occupancy_map() -> Dictionary:
	var map := {}

	for child in get_children():
		if not child.has_method("get"):
			continue

		if not "brick_type" in child:
			continue

		var grid_pos = ((child.position - Vector2(16,16)) / TILE_SIZE).round()
		var type = child.brick_type

		for tile in get_occupied_tiles(grid_pos, type):
			map[tile] = true

	return map
func move_enemies():
	var enemies := get_enemies().filter(func(e): return not e.get_meta("moving", false))
	sync_grid_to_children()
	# Sort bottom-first so that enemies in front move out of the way for those behind
	enemies.sort_custom(func(a,b): return a.grid_pos.y > b.grid_pos.y)

	for enemy in enemies:
		# 1. Determine how many steps this specific enemy takes
		var steps_to_take = enemy.step if "step" in enemy else 1
		var tween = create_tween()
		
		# 2. Run the movement logic for each step
		for s in range(steps_to_take):
			var gp = enemy.grid_pos

			# Check if enemy is already at the attack line
			if gp.y >= GRID_H - 2:
				if enemy.has_method("attack"):
					enemy.attack()
				break # Stop attempting to move if attacking

			# Movement AI logic
			var preferred_dir := -1 if gp.x <= 4 else 1
			var down = gp + Vector2(0, 1)
			var side1 = gp + Vector2(preferred_dir, 0)
			var side2 = gp + Vector2(-preferred_dir, 0)

			var target := Vector2.ZERO
			var found := false

			if in_bounds(down) and grid[int(down.y)][int(down.x)] == -1:
				target = down
				found = true
			elif in_bounds(side1) and grid[int(side1.y)][int(side1.x)] == -1:
				target = side1
				found = true
			elif in_bounds(side2) and grid[int(side2.y)][int(side2.x)] == -1:
				target = side2
				found = true

			if found:
				# 3. Update Grid IMMEDIATELY 
				# This ensures the next step (or next enemy) sees the new position
				grid[int(gp.y)][int(gp.x)] = -1
				grid[int(target.y)][int(target.x)] = enemy.brick_type
				
				enemy.grid_pos = target
				enemy.set_meta("moving", true)

				# 4. Chain the movement animation
				# Tweens called on the same object play sequentially
				tween.tween_property(enemy, "position", grid_to_world(target), MOVE_TIME)
			else:
				# If blocked, stop trying to take further steps this turn
				break

		# Clean up meta tag when all steps are finished
		tween.finished.connect(func():
			if is_instance_valid(enemy):
				enemy.set_meta("moving", false)
		)
func is_in_bounds(grid_pos: Vector2) -> bool:
	return grid_pos.x >= MIN_X and grid_pos.x <= MAX_X

func get_enemies() -> Array:
	var enemies := []
	for child in get_children():
		if child.has_method("is_enemy"):
			enemies.append(child)
	return enemies

func on_coin_collected():
	collected_coins += 1
	
func reduce_hp(amount: int):
	print("level reducing hp")
	# The parent of level/endless is the Main Script
	if gameref.has_method("take_damage"):
		gameref.take_damage(amount)
func count_hit(amount):
	get_parent().add_streak(amount)
func sync_grid_to_children():
	# 1. Reset the grid to empty (-1)
	for y in range(GRID_H):
		for x in range(GRID_W):
			grid[y][x] = -1
			
	# 2. Re-map every existing child to the grid
	for child in get_children():
		# Skip nodes that are already dying or don't have grid data
		if child.is_queued_for_deletion() or !("grid_pos" in child):
			continue
			
		var type = child.brick_type if "brick_type" in child else -1
		if type != -1:
			var tiles = get_occupied_tiles(Vector2i(child.grid_pos), type)
			for tile in tiles:
				if in_bounds(tile):
					grid[tile.y][tile.x] = type
