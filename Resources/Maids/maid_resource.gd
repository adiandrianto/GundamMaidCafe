extends Resource
class_name MaidResource

enum Personality{ELEGANT, TSUNDERE, KUUDERE}

@export var maid_name: StringName
@export var personality: Personality
@export var portrait: CompressedTexture2D
@export var sprite: CompressedTexture2D
@export var service_duration: float 
