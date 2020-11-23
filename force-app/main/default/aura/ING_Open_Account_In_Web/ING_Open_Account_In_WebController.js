({
    closeMethodInAuraController: function () {
        $A.get("e.force:closeQuickAction").fire();
    }
})