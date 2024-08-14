extends Node

enum GremlinGoal {
	POND,
	EAT,
	EAT2,
	COFFEE,
	SLEEP,
	TV,
	TOILETT,
	POSTAL,
	CLEANING,
	WORLD_PLANTING,
	WORLD_HARVEST,
}

var cntNonWorldActivities = GremlinGoal.CLEANING + 1
