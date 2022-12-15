class Pill:
    def __init__(self, name, total_qty, before_meal, intake_qty, intake_time, intake_daily, selected_days=None):
        self.name = name
        self.total_qty = total_qty
        self.before_meal = before_meal
        self.intake_qty = intake_qty
        self.intake_time = intake_time
        self.intake_daily = intake_daily
        self.selected_days = selected_days
