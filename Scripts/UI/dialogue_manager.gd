extends Node

var customer: Customer = owner
@export var label_text: Label

func check_for_order(customer: Customer) ->void:
    match customer.customerPreference:
        GlobalConstants.Personality.ELEGANT:
          label_text.text = ("I would love to be served by an elegant maid!")
        GlobalConstants.Personality.TSUNDERE:
          label_text.text = ("I would love to be served by a tsundere-type maid!")
        GlobalConstants.Personality.IMOUTO:
          label_text.text = ("I would love to be served by an imouto-type maid!")
        GlobalConstants.Personality.KUUDERE:
          label_text.text = ("I would love to be served by a kuudere-type maid!")
        GlobalConstants.Personality.YANDERE:
          label_text.text = ("I would love to be served by a yandere-type maid!")
        GlobalConstants.Personality.ONEESAN:
          label_text.text = ("I would love to be served by a onee-san type maid!")

