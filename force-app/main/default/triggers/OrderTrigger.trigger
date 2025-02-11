trigger OrderTrigger on Order (before update, after update) {
	if(trigger.isBefore) {
		OrderTriggerController.CalculateTotalWithShipment(Trigger.new);
	}
	if(trigger.isAfter) {
		OrderTriggerController.UpdateAccountCA(Trigger.new, Trigger.oldMap);
	}
}