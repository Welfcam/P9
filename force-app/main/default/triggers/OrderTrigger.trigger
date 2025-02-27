//Trigger sur Order
trigger OrderTrigger on Order (before update, after update) {
	//Avant une mise à jour d'Order, la calcul du totalWithShipment est effectué
	if(trigger.isBefore) {
		OrderTriggerController.calculateTotalWithShipment(Trigger.new);
	}
	//Après une mise à jour de l'Order, le CA du compte asscoié est mis à jour
	if(trigger.isAfter) {
		OrderTriggerController.updateAccountCA(Trigger.new, Trigger.oldMap);
	}
}