trigger OrderTrigger on Order (before update, after update) {
	if(trigger.isBefore) {
		OrderTriggerController.calculateTotalWithShipment(Trigger.new);
	}
	if(trigger.isAfter) {
		OrderTriggerController.updateAccountCA(Trigger.new, Trigger.oldMap);
	}
}